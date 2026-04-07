import uuid
from datetime import datetime
from pydantic import BaseModel


class ProgressResponse(BaseModel):
    id: uuid.UUID
    user_id: uuid.UUID
    jilid: int
    total_lessons: int
    completed_lessons: int
    average_score: float
    best_score: float
    total_practice_count: int
    updated_at: datetime

    model_config = {"from_attributes": True}


class ProgressDashboard(BaseModel):
    total_evaluations: int
    average_score: float
    best_score: float
    total_practice_minutes: float
    streak_days: int
    jilid_progress: list[ProgressResponse]
    recent_evaluations: list[dict]
