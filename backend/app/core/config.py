from typing import List
from pydantic_settings import BaseSettings  # type: ignore

class Settings(BaseSettings):
    PROJECT_NAME: str = "SapiMadura AI Backend"
    API_V1_STR: str = "/api/v1"
    DEBUG: bool = True
    DATABASE_URL: str = "sqlite:///./sapi_madura_cloud.db"
    BACKEND_CORS_ORIGINS: List[str] = ["*"]

    class Config:
        env_file = ".env"
        case_sensitive = True

settings = Settings()
