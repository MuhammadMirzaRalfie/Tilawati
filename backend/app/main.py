import os
from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.config import settings
from app.database import init_db
from app.routers import auth, lessons, evaluation, progress


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    os.makedirs(settings.UPLOAD_DIR, exist_ok=True)
    await init_db()
    print("✅ Database tables created")
    print("✅ Tilawati API is ready!")
    yield
    # Shutdown
    print("👋 Shutting down Tilawati API...")


app = FastAPI(
    title="Tilawati API",
    description="API untuk Aplikasi Pembelajaran dan Evaluasi Bacaan Al-Qur'an Berbasis AI",
    version="1.0.0",
    lifespan=lifespan,
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register routers
app.include_router(auth.router)
app.include_router(lessons.router)
app.include_router(evaluation.router)
app.include_router(progress.router)


@app.get("/")
async def root():
    return {
        "app": "Tilawati API",
        "version": "1.0.0",
        "description": "Aplikasi Pembelajaran dan Evaluasi Bacaan Al-Qur'an Berbasis AI",
        "docs": "/docs",
    }


@app.get("/health")
async def health():
    return {"status": "healthy"}
