import uuid
from datetime import datetime
from sqlalchemy import String, Integer, Float, DateTime, ForeignKey, Text, func
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import Mapped, mapped_column
from app.database import Base


class Evaluation(Base):
    __tablename__ = "evaluations"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True
    )
    jilid: Mapped[int] = mapped_column(Integer, nullable=False)
    lesson_number: Mapped[int] = mapped_column(Integer, nullable=False)
    lesson_title: Mapped[str] = mapped_column(String(200), nullable=False)
    audio_path: Mapped[str | None] = mapped_column(String(500), nullable=True)
    overall_score: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    makharijul_huruf_score: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    tajwid_score: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    kelancaran_score: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    feedback_json: Mapped[dict | None] = mapped_column(JSONB, nullable=True)
    phoneme_details: Mapped[dict | None] = mapped_column(JSONB, nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
