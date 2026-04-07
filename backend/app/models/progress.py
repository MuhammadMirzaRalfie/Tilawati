import uuid
from datetime import datetime
from sqlalchemy import Integer, Float, DateTime, ForeignKey, func
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column
from app.database import Base


class Progress(Base):
    __tablename__ = "progress"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True
    )
    jilid: Mapped[int] = mapped_column(Integer, nullable=False)
    total_lessons: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    completed_lessons: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    average_score: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    best_score: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    total_practice_count: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )
