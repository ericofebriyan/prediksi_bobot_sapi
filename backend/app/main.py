import os
import sys

# Memastikan direktori backend dapat diakses
BACKEND_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if BACKEND_DIR not in sys.path:
    sys.path.insert(0, BACKEND_DIR)

from fastapi import FastAPI  # type: ignore
from fastapi.middleware.cors import CORSMiddleware  # type: ignore

try:
    from app.core.config import settings
    from app.routers import prediction, consultation, sync
except ImportError:
    from .core.config import settings
    from .routers import prediction, consultation, sync

app = FastAPI(
    title=settings.PROJECT_NAME,
    description="Backend API untuk Aplikasi Prediksi Waktu Panen Sapi Madura & Konsultasi Dokter Hewan",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
)

# Setup CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.BACKEND_CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register Routers
app.include_router(prediction.router, prefix=settings.API_V1_STR)
app.include_router(consultation.router, prefix=settings.API_V1_STR)
app.include_router(sync.router, prefix=settings.API_V1_STR)

@app.get("/")
def root():
    return {
        "app": settings.PROJECT_NAME,
        "status": "online",
        "version": "1.0.0",
        "docs": "/docs",
        "description": "API Gateway aktif mendukung Mode Online SapiMadura Mobile App",
    }
