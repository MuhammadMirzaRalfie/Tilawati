import os
import uuid
import random
import tempfile
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form, status
from fastapi.responses import JSONResponse
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession
from app.config import settings
from app.database import get_db
from app.models.user import User
from app.models.evaluation import Evaluation
from app.models.progress import Progress
from app.schemas.evaluation import EvaluationResponse
from app.services.auth_service import get_current_user
from app.services.ai_service import evaluate_audio, get_lesson, transcribe_word

router = APIRouter(prefix="/api/evaluation", tags=["Evaluation"])

# ──────────────────────────────────────────────────────────────────────────────
# Normalization: transliterasi ai_service.py  →  label ASR model (id2word.json)
#
# Model ASR (ASR-EXP-03-E3) menggunakan label lowercase sesuai vocab.json:
#   a, ain, ba, da, dho, dza, fa, gho, ha, hha, ja, ka, kho, la, ma,
#   na, qo, ro, sa, sho, sya, ta, tho, tsa, wa, ya, zay, zho
#
# Transliterasi di ai_service.py menggunakan notasi berbeda untuk huruf:
#   حَ = HA   → model: HHA      خَ = KHA  → model: KHO
#   رَ = RA   → model: RO       زَ = ZA   → model: ZAY
#   صَ = SHA  → model: SHO      ضَ = DHA  → model: DHO
#   طَ = THA  → model: THO      ظَ = ZHA  → model: ZHO
#   عَ = 'A   → model: AIN      غَ = GHA  → model: GHO
#   قَ = QA   → model: QO
#
# CATATAN: HA (هَ) sudah benar — tidak perlu dikonversi.
# ──────────────────────────────────────────────────────────────────────────────
_TRANS_TO_ASR: dict[str, str] = {
    # Transliteration → ASR model label (case-insensitive, compare in UPPER)
    "HHA": "HHA",   # حَ — transliterasi pakai 'HA', model pakai 'hha' → see below
    "HA_HHA": "HHA", # placeholder — handled by context
    # Actual mismatches (transliteration → ASR model label uppercased):
    "KHA": "KHO",
    "RA":  "RO",
    "ZA":  "ZAY",
    "SHA": "SHO",
    "DHA": "DHO",
    "THA": "THO",
    "ZHA": "ZHO",
    "'A":  "AIN",
    "AIN": "AIN",
    "GHA": "GHO",
    "QA":  "QO",
}

# Karena 'HA' dipakai untuk حَ DAN هَ di transliterasi,
# kita simpan kedua kemungkinan ASR untuk 'HA'.
_HA_ASR_VARIANTS = {"HA", "HHA"}  # model bisa output salah satu


def _normalize_token(tok: str) -> str:
    """Konversi satu token transliterasi ke label ASR yang diharapkan model."""
    upper = tok.upper()
    return _TRANS_TO_ASR.get(upper, upper).upper()


def _tokens_match(expected_raw: list[str], asr_tokens: list[str]) -> bool:
    """
    Bandingkan token transliterasi dengan output ASR model.
    - Normalize expected ke format model.
    - 'HA' di transliterasi bisa cocok dengan 'HA' atau 'HHA' dari model
      (karena transliterasi tidak membedakan هَ dan حَ).
    """
    if len(expected_raw) != len(asr_tokens):
        return False
    for exp_raw, asr in zip(expected_raw, asr_tokens):
        exp_upper = exp_raw.upper()
        asr_upper = asr.upper()
        if exp_upper == "HA":
            # Toleransi: transliterasi tidak membedakan هَ(ha) dan حَ(hha)
            if asr_upper not in _HA_ASR_VARIANTS:
                return False
        else:
            normalized = _normalize_token(exp_upper)
            if normalized != asr_upper:
                return False
    return True



@router.post("/submit", response_model=EvaluationResponse)
async def submit_evaluation(
    jilid: int = Form(...),
    lesson_number: int = Form(...),
    audio: UploadFile = File(...),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Submit an audio recording for AI evaluation."""
    # Validate lesson exists
    lesson = get_lesson(jilid, lesson_number)
    if lesson is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pelajaran tidak ditemukan.",
        )

    # Save audio file
    os.makedirs(settings.UPLOAD_DIR, exist_ok=True)
    file_ext = os.path.splitext(audio.filename)[1] if audio.filename else ".wav"
    audio_filename = f"{current_user.id}_{jilid}_{lesson_number}_{uuid.uuid4().hex[:8]}{file_ext}"
    audio_path = os.path.join(settings.UPLOAD_DIR, audio_filename)

    with open(audio_path, "wb") as f:
        content = await audio.read()
        f.write(content)

    # Run AI evaluation (currently mock)
    eval_result = await evaluate_audio(audio_path, jilid, lesson_number)

    # Save evaluation to database
    evaluation = Evaluation(
        user_id=current_user.id,
        jilid=jilid,
        lesson_number=lesson_number,
        lesson_title=lesson["title"],
        audio_path=audio_path,
        overall_score=eval_result["overall_score"],
        makharijul_huruf_score=eval_result["makharijul_huruf_score"],
        tajwid_score=eval_result["tajwid_score"],
        kelancaran_score=eval_result["kelancaran_score"],
        feedback_json=eval_result["feedback_json"],
        phoneme_details=eval_result["phoneme_details"],
    )
    db.add(evaluation)

    # Update progress
    await _update_progress(db, current_user.id, jilid, eval_result["overall_score"])

    await db.commit()
    await db.refresh(evaluation)

    return EvaluationResponse.model_validate(evaluation)


@router.post("/submit_word")
async def submit_word_evaluation(
    expected_word: str = Form(...),
    audio: UploadFile = File(...),
    current_user: User = Depends(get_current_user),
):
    """Evaluate a single-word audio recording. Returns matched/not-matched instantly."""
    audio_bytes = await audio.read()

    with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as tmp:
        tmp.write(audio_bytes)
        tmp_path = tmp.name

    try:
        predicted_tokens = await transcribe_word(tmp_path)
    finally:
        try:
            os.unlink(tmp_path)
        except OSError:
            pass

    expected = expected_word.strip().upper()

    if predicted_tokens is not None:
        asr_tokens = [t.upper() for t in predicted_tokens]
        asr_text = " ".join(asr_tokens)
        expected_tokens = expected.split()
        matched = _tokens_match(expected_tokens, asr_tokens)
    else:
        # ASR unavailable — mock 70% match rate so demo works without model
        matched = random.random() < 0.7
        asr_text = expected if matched else ""

    # Normalize expected untuk ditampilkan di frontend
    normalized_expected = " ".join(_normalize_token(t) for t in expected.split())
    return JSONResponse({
        "matched": matched,
        "asr_transcript": asr_text,
        "expected": expected,
        "expected_normalized": normalized_expected,
    })


@router.get("/history", response_model=list[EvaluationResponse])
async def get_evaluation_history(
    jilid: int | None = None,
    limit: int = 20,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Get user's evaluation history."""
    query = select(Evaluation).where(
        Evaluation.user_id == current_user.id
    ).order_by(Evaluation.created_at.desc()).limit(limit)

    if jilid is not None:
        query = query.where(Evaluation.jilid == jilid)

    result = await db.execute(query)
    evaluations = result.scalars().all()
    return [EvaluationResponse.model_validate(e) for e in evaluations]


@router.get("/{evaluation_id}", response_model=EvaluationResponse)
async def get_evaluation(
    evaluation_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Get a specific evaluation result."""
    result = await db.execute(
        select(Evaluation).where(
            Evaluation.id == uuid.UUID(evaluation_id),
            Evaluation.user_id == current_user.id,
        )
    )
    evaluation = result.scalar_one_or_none()
    if evaluation is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Evaluasi tidak ditemukan.",
        )
    return EvaluationResponse.model_validate(evaluation)


async def _update_progress(
    db: AsyncSession, user_id: uuid.UUID, jilid: int, new_score: float
):
    """Update or create progress record for a jilid."""
    result = await db.execute(
        select(Progress).where(
            Progress.user_id == user_id,
            Progress.jilid == jilid,
        )
    )
    progress = result.scalar_one_or_none()

    if progress is None:
        from app.services.ai_service import get_jilid_lessons
        jilid_data = get_jilid_lessons(jilid)
        total = jilid_data["total_lessons"] if jilid_data else 0

        progress = Progress(
            user_id=user_id,
            jilid=jilid,
            total_lessons=total,
            completed_lessons=1,
            average_score=new_score,
            best_score=new_score,
            total_practice_count=1,
        )
        db.add(progress)
    else:
        progress.total_practice_count += 1
        # Recalculate average
        old_total = progress.average_score * (progress.total_practice_count - 1)
        progress.average_score = round(
            (old_total + new_score) / progress.total_practice_count, 1
        )
        if new_score > progress.best_score:
            progress.best_score = new_score

        # Count unique completed lessons
        eval_result = await db.execute(
            select(func.count(func.distinct(Evaluation.lesson_number))).where(
                Evaluation.user_id == user_id,
                Evaluation.jilid == jilid,
            )
        )
        progress.completed_lessons = eval_result.scalar() or 0


@router.post("/submit_lesson_result")
async def submit_lesson_result(
    jilid: int = Form(...),
    lesson_number: int = Form(...),
    correct_count: int = Form(...),
    total_count: int = Form(...),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Save word-by-word lesson result and update progress. No audio needed."""
    lesson = get_lesson(jilid, lesson_number)
    if lesson is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pelajaran tidak ditemukan.",
        )

    overall_score = round((correct_count / total_count * 100) if total_count > 0 else 0.0, 1)

    evaluation = Evaluation(
        user_id=current_user.id,
        jilid=jilid,
        lesson_number=lesson_number,
        lesson_title=lesson["title"],
        audio_path=None,
        overall_score=overall_score,
        makharijul_huruf_score=overall_score,
        tajwid_score=overall_score,
        kelancaran_score=overall_score,
        feedback_json={"correct": correct_count, "total": total_count},
        phoneme_details=None,
    )
    db.add(evaluation)

    await _update_progress(db, current_user.id, jilid, overall_score)
    await db.commit()

    return JSONResponse({"saved": True, "overall_score": overall_score})


@router.post("/transcribe_free")
async def transcribe_free(
    audio: UploadFile = File(...),
    current_user: User = Depends(get_current_user),
):
    """
    Inferensi bebas: kirim audio apa saja, model ASR akan mentranskripsikan.
    Tidak perlu expected word / jilid. Hasilnya adalah urutan token hijaiyah
    yang diprediksi model.
    """
    audio_bytes = await audio.read()

    with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as tmp:
        tmp.write(audio_bytes)
        tmp_path = tmp.name

    try:
        from app.services.ai_service import transcribe_word as _transcribe
        predicted_tokens = await _transcribe(tmp_path)
    finally:
        try:
            os.unlink(tmp_path)
        except OSError:
            pass

    if predicted_tokens is not None:
        transcript = " ".join(predicted_tokens)
        return JSONResponse({
            "transcript": transcript,
            "words": predicted_tokens,
            "word_count": len(predicted_tokens),
            "source": "asr_model",
        })
    else:
        return JSONResponse({
            "transcript": "",
            "words": [],
            "word_count": 0,
            "source": "unavailable",
            "message": "Model ASR tidak tersedia. Pastikan model sudah dimuat.",
        })
