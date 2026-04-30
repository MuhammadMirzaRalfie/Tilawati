import os
import uuid
from fastapi import APIRouter, Depends, File, Form, HTTPException, UploadFile, status
from app.config import settings
from app.models.user import User
from app.services.auth_service import get_current_user
from app.services.classification_inference import (
    HIJAIYAH_META,
    classify_file,
)

router = APIRouter(prefix="/api/glossary", tags=["Glossary"])


@router.get("/letters")
async def list_letters():
    """Daftar 28 huruf hijaiyah dengan metadata (Arab, makhraj, warna)."""
    letters = []
    for label, meta in HIJAIYAH_META.items():
        letters.append({
            "label": label,
            "arabic": meta["arabic"],
            "makhraj": meta["makhraj"],
            "color": meta["color"],
        })
    return {"letters": letters}


@router.post("/classify")
async def classify_letter(
    expected_label: str = Form(...),
    audio: UploadFile = File(...),
    current_user: User = Depends(get_current_user),
):
    """
    Klasifikasi huruf dari rekaman audio.
    - expected_label: huruf yang seharusnya diucapkan, misal "BA"
    - audio: file WAV rekaman user
    """
    expected_label = expected_label.upper()
    if expected_label not in HIJAIYAH_META:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Label '{expected_label}' tidak dikenal. Gunakan salah satu dari: {list(HIJAIYAH_META.keys())}",
        )

    os.makedirs(settings.UPLOAD_DIR, exist_ok=True)
    filename = f"glossary_{current_user.id}_{uuid.uuid4().hex[:8]}.wav"
    audio_path = os.path.join(settings.UPLOAD_DIR, filename)

    content = await audio.read()
    with open(audio_path, "wb") as f:
        f.write(content)

    try:
        result = classify_file(audio_path)
    except (RuntimeError, ValueError) as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

    predicted = result["predicted_label"]
    is_correct = predicted == expected_label
    confidence_pct = round(result["confidence"] * 100, 1)

    meta_expected = HIJAIYAH_META[expected_label]
    meta_predicted = HIJAIYAH_META.get(predicted, {})

    return {
        "expected_label": expected_label,
        "predicted_label": predicted,
        "is_correct": is_correct,
        "confidence": result["confidence"],
        "confidence_pct": confidence_pct,
        "top3": result["top3"],
        "feedback": _generate_feedback(is_correct, confidence_pct, expected_label, predicted),
        "expected_meta": meta_expected,
        "predicted_meta": meta_predicted,
    }


def _generate_feedback(is_correct: bool, confidence_pct: float, expected: str, predicted: str) -> dict:
    if is_correct and confidence_pct >= 80:
        return {
            "status": "excellent",
            "message": f"Masya Allah! Pengucapan {expected} sangat tepat.",
            "tip": None,
        }
    if is_correct and confidence_pct >= 60:
        return {
            "status": "good",
            "message": f"Pengucapan {expected} sudah benar, terus latihan!",
            "tip": "Coba lebih yakin saat mengucapkan huruf ini.",
        }
    if is_correct:
        return {
            "status": "pass",
            "message": f"Pengucapan {expected} terdeteksi benar tapi kurang jelas.",
            "tip": "Ucapkan lebih tegas dan pastikan posisi lidah sesuai makhraj.",
        }
    # salah
    return {
        "status": "incorrect",
        "message": f"Terdeteksi sebagai '{predicted}', bukan '{expected}'.",
        "tip": f"Perhatikan makhraj huruf {expected}. Coba lagi.",
    }
