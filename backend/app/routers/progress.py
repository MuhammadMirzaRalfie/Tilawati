from fastapi import APIRouter, Depends
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.models.user import User
from app.models.evaluation import Evaluation
from app.models.progress import Progress
from app.schemas.progress import ProgressResponse, ProgressDashboard
from app.services.auth_service import get_current_user

router = APIRouter(prefix="/api/progress", tags=["Progress"])


@router.get("/dashboard", response_model=ProgressDashboard)
async def get_dashboard(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Get user's progress dashboard with stats."""
    # Get total evaluations
    total_eval_result = await db.execute(
        select(func.count(Evaluation.id)).where(
            Evaluation.user_id == current_user.id
        )
    )
    total_evaluations = total_eval_result.scalar() or 0

    # Get average and best score
    score_result = await db.execute(
        select(
            func.avg(Evaluation.overall_score),
            func.max(Evaluation.overall_score),
        ).where(Evaluation.user_id == current_user.id)
    )
    score_row = score_result.one()
    average_score = round(float(score_row[0] or 0), 1)
    best_score = round(float(score_row[1] or 0), 1)

    # Get jilid progress
    progress_result = await db.execute(
        select(Progress).where(
            Progress.user_id == current_user.id
        ).order_by(Progress.jilid)
    )
    jilid_progress = [
        ProgressResponse.model_validate(p) for p in progress_result.scalars().all()
    ]

    # Get recent evaluations
    recent_result = await db.execute(
        select(Evaluation).where(
            Evaluation.user_id == current_user.id
        ).order_by(Evaluation.created_at.desc()).limit(10)
    )
    recent_evaluations = []
    for e in recent_result.scalars().all():
        recent_evaluations.append({
            "id": str(e.id),
            "jilid": e.jilid,
            "lesson_number": e.lesson_number,
            "lesson_title": e.lesson_title,
            "overall_score": e.overall_score,
            "created_at": e.created_at.isoformat(),
        })

    return ProgressDashboard(
        total_evaluations=total_evaluations,
        average_score=average_score,
        best_score=best_score,
        total_practice_minutes=total_evaluations * 2.5,  # estimate
        streak_days=min(total_evaluations, 7),  # simplified
        jilid_progress=jilid_progress,
        recent_evaluations=recent_evaluations,
    )


@router.get("/jilid/{jilid_id}", response_model=ProgressResponse | None)
async def get_jilid_progress(
    jilid_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Get progress for a specific jilid."""
    result = await db.execute(
        select(Progress).where(
            Progress.user_id == current_user.id,
            Progress.jilid == jilid_id,
        )
    )
    progress = result.scalar_one_or_none()
    if progress is None:
        return None
    return ProgressResponse.model_validate(progress)
