import uuid
from datetime import datetime
from pydantic import BaseModel


class EvaluationResponse(BaseModel):
    id: uuid.UUID
    user_id: uuid.UUID
    jilid: int
    lesson_number: int
    lesson_title: str
    overall_score: float
    makharijul_huruf_score: float
    tajwid_score: float
    kelancaran_score: float
    feedback_json: dict | None = None
    phoneme_details: dict | None = None
    created_at: datetime

    model_config = {"from_attributes": True}


class EvaluationSummary(BaseModel):
    id: uuid.UUID
    jilid: int
    lesson_number: int
    lesson_title: str
    overall_score: float
    created_at: datetime

    model_config = {"from_attributes": True}


class LessonInfo(BaseModel):
    jilid: int
    lesson_number: int
    title: str
    arabic_text: str
    transliteration: str
    description: str
    audio_reference_url: str | None = None


class JilidInfo(BaseModel):
    jilid: int
    title: str
    description: str
    total_lessons: int
    icon: str
    color: str
    lessons: list[LessonInfo] = []
