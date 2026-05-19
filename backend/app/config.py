import os
from dotenv import load_dotenv

load_dotenv()


class Settings:
    DATABASE_URL: str = os.getenv(
        "DATABASE_URL",
        "postgresql+asyncpg://tilawati:tilawati123@localhost:5432/tilawati_db"
    )
    DATABASE_URL_SYNC: str = os.getenv(
        "DATABASE_URL_SYNC",
        "postgresql://tilawati:tilawati123@localhost:5432/tilawati_db"
    )
    SECRET_KEY: str = os.getenv("SECRET_KEY", "tilawati-dev-secret-key-2024")
    ALGORITHM: str = os.getenv("ALGORITHM", "HS256")
    ACCESS_TOKEN_EXPIRE_MINUTES: int = int(
        os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "1440")
    )
    UPLOAD_DIR: str = os.getenv("UPLOAD_DIR", "./uploads")
    ASR_SERVICE_URL: str = os.getenv("ASR_SERVICE_URL", "")
    ASR_MODEL_DIR: str = os.getenv("ASR_MODEL_DIR", "")
    CLASSIFICATION_MODEL_DIR: str = os.getenv("CLASSIFICATION_MODEL_DIR", "")
    CLASSIFIER_SERVICE_URL: str = os.getenv("CLASSIFIER_SERVICE_URL", "")


settings = Settings()
