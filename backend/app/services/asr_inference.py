"""
ASR inference lokal — model HPT-D (CER 0.1013, WER 0.2025)
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
    # default: model/ di sebelah direktori backend (untuk dev lokal)
    return Path(__file__).parent.parent.parent.parent / "Model" / "Deploy" / "api" / "model"


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

    print(f"[asr_inference] Model HPT-D siap. Device: {_device}", flush=True)


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


def transcribe_file(audio_path: str) -> dict:
    """
    Transkripsi file audio lokal.
    Return: {"transcript": str, "words": list[str], "word_count": int, "duration_ms": float}
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

    pred_ids = torch.argmax(logits, dim=-1)[0].cpu().numpy()
    transcript = _decode_ctc(pred_ids)
    words = transcript.split() if transcript else []

    return {
        "transcript": transcript,
        "words": words,
        "word_count": len(words),
        "duration_ms": duration_ms,
    }
