from fastapi import APIRouter, HTTPException, status
from app.services.ai_service import get_all_jilids, get_jilid_lessons, get_lesson

router = APIRouter(prefix="/api/lessons", tags=["Lessons"])


@router.get("/jilids")
async def list_jilids():
    """Get all available Tilawati jilids."""
    return {"jilids": get_all_jilids()}


@router.get("/jilids/{jilid_id}")
async def get_jilid(jilid_id: int):
    """Get details and lessons for a specific jilid."""
    data = get_jilid_lessons(jilid_id)
    if data is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Jilid {jilid_id} tidak ditemukan.",
        )
    return data


@router.get("/jilids/{jilid_id}/lessons/{lesson_number}")
async def get_lesson_detail(jilid_id: int, lesson_number: int):
    """Get a specific lesson detail."""
    lesson = get_lesson(jilid_id, lesson_number)
    if lesson is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Pelajaran {lesson_number} di Jilid {jilid_id} tidak ditemukan.",
        )
    return lesson
