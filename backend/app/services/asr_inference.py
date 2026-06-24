"""
ASR inference lokal — model ASR-EXP-03-E3 (CER 0.0382, WER 0.0712, Acc 92.75%)
Dimuat sekali saat startup, dipakai oleh ai_service.evaluate_audio().
"""

import io
import json
from pathlib import Path

import librosa
import numpy as np
import torch

SAMPLE_RATE = 16000
PAD_ID = 0
MIN_AUDIO_SAMPLES = 160

_processor = None
_model = None
_device = None
_id2word = None


def _get_model_dir() -> Path:
    from app.config import settings
    if settings.ASR_MODEL_DIR:
        return Path(settings.ASR_MODEL_DIR)
    # default: model ASR-EXP-03-E3 (dev lokal)
    return (
        Path(__file__).parent.parent.parent.parent.parent
        / "model"
        / "Model Final ASR"
        / "ASR-EXP-03-E3"
        / "final model exp03e3"
        / "asr_hpt_e3"
        / "best_model"
    )


def load_asr_model():
    global _processor, _model, _device, _id2word
    if _model is not None:
        return

    from transformers import Wav2Vec2ForCTC, Wav2Vec2Processor

    model_dir = _get_model_dir()
    model_path = str(model_dir.resolve())

    print(f"[asr_inference] Memuat model dari: {model_path}", flush=True)
    _processor = Wav2Vec2Processor.from_pretrained(model_path, local_files_only=True)
    _model = Wav2Vec2ForCTC.from_pretrained(model_path, local_files_only=True)
    _model.config.mask_time_prob = 0.0
    _model.config.mask_feature_prob = 0.0
    _model.eval()

    _device = "cuda" if torch.cuda.is_available() else "cpu"
    _model = _model.to(_device)

    with open(model_dir / "id2word.json") as f:
        raw = json.load(f)
    _id2word = {int(k): v for k, v in raw.items()}

    print(f"[asr_inference] Model ASR-EXP-03-E3 siap. Device: {_device}", flush=True)


def warmup_asr_model():
    """
    Jalankan satu dummy forward pass setelah model dimuat.
    Ini memaksa PyTorch mengalokasikan buffer memory, mengkompilasi CPU kernels,
    dan menginisialisasi thread pool — sehingga inferensi pertama user tidak lambat.
    """
    if _model is None:
        return
    try:
        # Buat audio sintetis 0.5 detik (8000 sampel) berisi silence
        dummy_speech = np.zeros(8000, dtype=np.float32)
        inputs = _processor(
            dummy_speech, sampling_rate=SAMPLE_RATE, return_tensors="pt", padding=True
        )
        input_values = inputs.input_values.to(_device)
        attention_mask = inputs.attention_mask.to(_device)
        with torch.inference_mode():
            _ = _model(input_values, attention_mask=attention_mask).logits
        print("[asr_inference] ✅ Warm-up selesai — model siap tanpa cold start.", flush=True)
    except Exception as e:
        print(f"[asr_inference] ⚠️  Warm-up gagal (tidak kritis): {e}", flush=True)


def _decode_ctc(pred_ids: np.ndarray) -> str:
    prev = None
    words = []
    for id_ in pred_ids:
        id_ = int(id_)
        if id_ == PAD_ID:
            prev = None
            continue
        if id_ == prev:
            continue
        if id_ in _id2word:
            words.append(_id2word[id_])
        prev = id_
    return " ".join(words)


def _decode_ctc_topk(logits_np: np.ndarray, k: int = 3) -> tuple[list[str], list[list[dict]]]:
    """
    Greedy CTC decode + top-k kandidat per posisi huruf.

    Untuk tiap huruf yang ter-decode, ambil k label teratas di FRAME PUNCAK huruf
    tersebut (frame dengan probabilitas tertinggi untuk huruf itu). Blank/pad dibuang.

    logits_np: array [T, V] (satu sampel, sudah di-CPU).
    Return: (words, words_topk)
      words      : list[str]                       — urutan huruf (sama dgn _decode_ctc)
      words_topk : list[list[{"label","conf"}]]    — k kandidat per posisi huruf
    """
    # softmax numerik-stabil pada [T, V]
    shifted = logits_np - logits_np.max(axis=-1, keepdims=True)
    exp = np.exp(shifted)
    probs = exp / exp.sum(axis=-1, keepdims=True)
    pred_ids = probs.argmax(axis=-1)

    # Kelompokkan path argmax jadi segmen huruf (collapse: skip blank, gabung duplikat)
    segments: list[tuple[int, list[int]]] = []
    prev, cur = None, []
    for t, idv in enumerate(pred_ids):
        idv = int(idv)
        if idv == PAD_ID:
            if cur:
                segments.append((prev, cur)); cur = []
            prev = None
            continue
        if idv == prev:
            cur.append(t)
        else:
            if cur:
                segments.append((prev, cur))
            cur = [t]; prev = idv
    if cur:
        segments.append((prev, cur))

    words: list[str] = []
    words_topk: list[list[dict]] = []
    for idv, frames in segments:
        if idv not in _id2word:
            continue
        words.append(_id2word[idv])
        peak = max(frames, key=lambda f: probs[f, idv])
        order = probs[peak].argsort()[::-1]
        cand = []
        for j in order:
            j = int(j)
            if j == PAD_ID or j not in _id2word:
                continue
            cand.append({"label": _id2word[j], "conf": round(float(probs[peak, j]), 4)})
            if len(cand) == k:
                break
        words_topk.append(cand)
    return words, words_topk


def transcribe_file(audio_path: str, with_topk: bool = False, k: int = 3) -> dict:
    """
    Transkripsi file audio lokal.
    Return: {"transcript": str, "words": list[str], "word_count": int, "duration_ms": float}
    Bila with_topk=True, tambah "words_topk": list[list[{"label","conf"}]] (top-k per huruf).
    """
    if _model is None:
        raise RuntimeError("ASR model belum dimuat.")

    speech, _ = librosa.load(audio_path, sr=SAMPLE_RATE, mono=True)
    speech = speech.astype(np.float32)
    duration_ms = round(len(speech) / SAMPLE_RATE * 1000, 1)

    if len(speech) < MIN_AUDIO_SAMPLES:
        raise ValueError(f"Audio terlalu pendek ({len(speech)} sampel).")

    inputs = _processor(speech, sampling_rate=SAMPLE_RATE, return_tensors="pt", padding=True)
    input_values = inputs.input_values.to(_device)
    attention_mask = inputs.attention_mask.to(_device)

    with torch.inference_mode():
        logits = _model(input_values, attention_mask=attention_mask).logits

    logits_np = logits[0].cpu().numpy()

    if with_topk:
        words, words_topk = _decode_ctc_topk(logits_np, k=k)
        transcript = " ".join(words)
        return {
            "transcript": transcript,
            "words": words,
            "words_topk": words_topk,
            "word_count": len(words),
            "duration_ms": duration_ms,
        }

    pred_ids = logits_np.argmax(axis=-1)
    transcript = _decode_ctc(pred_ids)
    words = transcript.split() if transcript else []

    return {
        "transcript": transcript,
        "words": words,
        "word_count": len(words),
        "duration_ms": duration_ms,
    }
