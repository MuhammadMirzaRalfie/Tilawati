"""
Classification inference untuk fitur Glosarium (klasifikasi 28 huruf hijaiyah).

Pola hybrid:
- Local model (Jonathan extended, 93.07% test acc) bila CLASSIFICATION_MODEL_DIR atau
  default path tersedia.
- Fallback ke HF Space POST /classify (XyroOne/Klasifikasi-Hijaiyah-Jonas) bila
  CLASSIFIER_SERVICE_URL diisi.

Public API:
  load_classification_model()         — startup loader (graceful, tidak crash bila gagal)
  classify_file(audio_path)           — local-only, sync
  classify_via_service(audio_path)    — HF Space, async
  classify_audio(audio_path)          — hybrid: local first, fallback HF Space, async
"""

import io
from pathlib import Path

import librosa
import numpy as np
import torch
import torch.nn.functional as F

SAMPLE_RATE = 16000
MIN_AUDIO_SAMPLES = 160

_processor = None
_model = None
_device = None
_id2label = None

# Metadata per huruf: Arab, makhraj, transliterasi
HIJAIYAH_META = {
    "A":   {"arabic": "اَ", "makhraj": "Tenggorokan bawah (glottal)", "color": "#1B5E20"},
    "BA":  {"arabic": "بَ", "makhraj": "Bibir (labial)", "color": "#0D47A1"},
    "TA":  {"arabic": "تَ", "makhraj": "Ujung lidah – gigi atas (alveolar)", "color": "#4A148C"},
    "TSA": {"arabic": "ثَ", "makhraj": "Ujung lidah – gigi (interdental)", "color": "#BF360C"},
    "JA":  {"arabic": "جَ", "makhraj": "Tengah lidah – langit-langit (palatal)", "color": "#006064"},
    "HHA": {"arabic": "حَ", "makhraj": "Tenggorokan tengah (pharyngeal)", "color": "#827717"},
    "KHO": {"arabic": "خَ", "makhraj": "Pangkal lidah – uvula (uvular)", "color": "#4E342E"},
    "DA":  {"arabic": "دَ", "makhraj": "Ujung lidah – gigi atas (alveolar)", "color": "#0D47A1"},
    "DZA": {"arabic": "ذَ", "makhraj": "Ujung lidah – gigi (interdental)", "color": "#1B5E20"},
    "RO":  {"arabic": "رَ", "makhraj": "Ujung lidah (alveolar trill)", "color": "#BF360C"},
    "ZAY": {"arabic": "زَ", "makhraj": "Ujung lidah – gigi (alveolar sibilant)", "color": "#006064"},
    "SA":  {"arabic": "سَ", "makhraj": "Ujung lidah – gigi (alveolar sibilant)", "color": "#4A148C"},
    "SYA": {"arabic": "شَ", "makhraj": "Tengah lidah – langit-langit (palatal sibilant)", "color": "#827717"},
    "SHO": {"arabic": "صَ", "makhraj": "Ujung lidah (emphatic sibilant)", "color": "#4E342E"},
    "DHO": {"arabic": "ضَ", "makhraj": "Sisi lidah – geraham (lateral emphatic)", "color": "#0D47A1"},
    "THO": {"arabic": "طَ", "makhraj": "Ujung lidah – gigi (emphatic alveolar)", "color": "#1B5E20"},
    "ZHO": {"arabic": "ظَ", "makhraj": "Ujung lidah – gigi (emphatic interdental)", "color": "#BF360C"},
    "AIN": {"arabic": "عَ", "makhraj": "Tenggorokan tengah (pharyngeal fricative)", "color": "#006064"},
    "GHO": {"arabic": "غَ", "makhraj": "Tenggorokan atas – uvula (uvular fricative)", "color": "#4A148C"},
    "FA":  {"arabic": "فَ", "makhraj": "Bibir bawah – gigi atas (labiodental)", "color": "#827717"},
    "QO":  {"arabic": "قَ", "makhraj": "Pangkal lidah – uvula (uvular stop)", "color": "#4E342E"},
    "KA":  {"arabic": "كَ", "makhraj": "Pangkal lidah – langit lunak (velar)", "color": "#0D47A1"},
    "LA":  {"arabic": "لَ", "makhraj": "Sisi ujung lidah (lateral alveolar)", "color": "#1B5E20"},
    "MA":  {"arabic": "مَ", "makhraj": "Bibir (labial nasal)", "color": "#BF360C"},
    "NA":  {"arabic": "نَ", "makhraj": "Ujung lidah (alveolar nasal)", "color": "#006064"},
    "HA":  {"arabic": "هَ", "makhraj": "Tenggorokan bawah (glottal fricative)", "color": "#4A148C"},
    "WA":  {"arabic": "وَ", "makhraj": "Bibir (labial-velar)", "color": "#827717"},
    "YA":  {"arabic": "يَ", "makhraj": "Tengah lidah – langit-langit (palatal)", "color": "#4E342E"},
}


def _get_model_dir() -> Path:
    from app.config import settings
    if settings.CLASSIFICATION_MODEL_DIR:
        return Path(settings.CLASSIFICATION_MODEL_DIR)
    # Default: Jonathan extended (Test Acc 93.07%, F1 0.9307) — model klasifikasi terpilih.
    # Path relatif dari backend/app/services/ → naik 4 level ke TilawatiApp/, masuk ke Model/.
    return (
        Path(__file__).parent.parent.parent.parent.parent
        / "Model"
        / "Model Klasifikasi"
        / "Model dengan Extended dataset"
        / "klasifikasi-jonathan-extended"
        / "final-jonatasgrosman-wav2vec2-large-xlsr-53-arabic"
    )


def load_classification_model():
    """Load model klasifikasi lokal. Graceful: tidak crash kalau path tidak ada
    (akan fallback ke HF Space saat request datang)."""
    global _processor, _model, _device, _id2label
    if _model is not None:
        return

    model_dir = _get_model_dir()
    if not model_dir.exists():
        print(
            f"[classification] Local model dir tidak ditemukan: {model_dir}. "
            f"Akan fallback ke HF Space bila CLASSIFIER_SERVICE_URL diset.",
            flush=True,
        )
        return

    from transformers import Wav2Vec2FeatureExtractor, Wav2Vec2ForSequenceClassification

    model_path = str(model_dir.resolve())

    print(f"[classification] Memuat model lokal dari: {model_path}", flush=True)
    _processor = Wav2Vec2FeatureExtractor.from_pretrained(model_path, local_files_only=True)
    _model = Wav2Vec2ForSequenceClassification.from_pretrained(model_path, local_files_only=True)
    _model.eval()

    _device = "cuda" if torch.cuda.is_available() else "cpu"
    _model = _model.to(_device)
    _id2label = _model.config.id2label

    print(f"[classification] Model Jonathan extended siap. Device: {_device}", flush=True)


def classify_file(audio_path: str) -> dict:
    """
    Klasifikasi huruf dari file audio lokal.
    Return: {
        "predicted_label": str,       # misal "BA"
        "confidence": float,           # 0.0–1.0
        "is_correct": bool,            # True jika confidence >= 0.5
        "top3": [{"label": str, "confidence": float}, ...]
    }
    """
    if _model is None:
        raise RuntimeError("Classification model belum dimuat.")

    speech, _ = librosa.load(audio_path, sr=SAMPLE_RATE, mono=True)
    speech = speech.astype(np.float32)

    if len(speech) < MIN_AUDIO_SAMPLES:
        raise ValueError(f"Audio terlalu pendek ({len(speech)} sampel).")

    inputs = _processor(speech, sampling_rate=SAMPLE_RATE, return_tensors="pt", padding=True)
    input_values = inputs.input_values.to(_device)

    with torch.no_grad():
        logits = _model(input_values).logits

    probs = F.softmax(logits[0], dim=-1).cpu().numpy()
    top_indices = probs.argsort()[::-1]

    predicted_id = int(top_indices[0])
    predicted_label = _id2label[predicted_id]
    confidence = float(probs[predicted_id])

    top3 = [
        {"label": _id2label[int(i)], "confidence": round(float(probs[i]), 4)}
        for i in top_indices[:3]
    ]

    return {
        "predicted_label": predicted_label,
        "confidence": round(confidence, 4),
        "is_correct": confidence >= 0.5,
        "top3": top3,
    }


async def classify_via_service(audio_path: str, timeout: float = 30.0) -> dict:
    """Klasifikasi via HF Space POST /classify. Return canonical format sama dengan
    classify_file() (predicted_label, confidence, is_correct, top3).

    HF Space response shape:
      {"predicted": "ba", "confidence": 0.96, "top_k":[{label,score}×5], "duration_ms": ...}

    Raise RuntimeError bila CLASSIFIER_SERVICE_URL tidak diset atau request gagal.
    """
    from app.config import settings

    if not settings.CLASSIFIER_SERVICE_URL:
        raise RuntimeError("CLASSIFIER_SERVICE_URL belum diset")

    import httpx

    url = settings.CLASSIFIER_SERVICE_URL.rstrip("/") + "/classify"
    async with httpx.AsyncClient(timeout=timeout) as client:
        with open(audio_path, "rb") as f:
            response = await client.post(url, files={"audio": f})
    response.raise_for_status()
    data = response.json()

    predicted_lower = data.get("predicted", "")
    confidence = float(data.get("confidence", 0.0))
    top_k = data.get("top_k", [])

    # Normalize ke canonical format (uppercase + top3 + is_correct flag)
    top3 = [
        {"label": item["label"].upper(), "confidence": round(float(item["score"]), 4)}
        for item in top_k[:3]
    ]

    return {
        "predicted_label": predicted_lower.upper(),
        "confidence": round(confidence, 4),
        "is_correct": confidence >= 0.5,
        "top3": top3,
    }


async def classify_audio(audio_path: str) -> dict:
    """Hybrid: pakai model lokal kalau sudah dimuat, fallback ke HF Space.

    Pola sama dengan ai_service._call_asr_service:
      1. Try local model (sync, dijalankan via executor agar tidak blokir event loop)
      2. Fallback ke HF Space bila local model tidak tersedia atau error

    Raise RuntimeError bila kedua jalur gagal.
    """
    import asyncio
    from app.config import settings

    # Coba local dulu
    if _model is not None:
        try:
            loop = asyncio.get_event_loop()
            return await asyncio.wait_for(
                loop.run_in_executor(None, classify_file, audio_path),
                timeout=8.0,
            )
        except asyncio.TimeoutError:
            print("[classification] Local timeout >8s, fallback ke HF Space.", flush=True)
        except Exception as e:
            print(f"[classification] Local error: {e}. Fallback ke HF Space.", flush=True)

    # Fallback HF Space
    if not settings.CLASSIFIER_SERVICE_URL:
        raise RuntimeError(
            "Local classification model belum dimuat dan CLASSIFIER_SERVICE_URL belum diset."
        )

    return await classify_via_service(audio_path)
