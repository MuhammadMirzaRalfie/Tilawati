import os
import uuid
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form, status
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession
from app.config import settings
from app.database import get_db
from app.models.user import User
from app.models.evaluation import Evaluation
from app.models.progress import Progress
from app.schemas.evaluation import EvaluationResponse
from app.services.auth_service import get_current_user
from app.services.ai_service import evaluate_audio, get_lesson

router = APIRouter(prefix="/api/evaluation", tags=["Evaluation"])


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
