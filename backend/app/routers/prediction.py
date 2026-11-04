from fastapi import APIRouter, HTTPException  # type: ignore

try:
    from app.schemas.prediction_schema import PredictionRequest, PredictionResponse
    from app.services.ml_inference import run_prediction_inference
except ImportError:
    from ..schemas.prediction_schema import PredictionRequest, PredictionResponse
    from ..services.ml_inference import run_prediction_inference

router = APIRouter(prefix="/predict", tags=["Prediksi Panen"])

@router.post("/harvest", response_model=PredictionResponse)
def predict_harvest(payload: PredictionRequest):
    """
    Endpoint Inferensi Model Regresi Ensemble:
    Menerima 10 parameter penggemukan Sapi Madura dan mengembalikan estimasi ADG,
    durasi panen, serta proyeksi titik kurva pertumbuhan bobot.
    """
    try:
        if payload.target_bobot <= payload.bobot_awal:
            raise HTTPException(status_code=400, detail="Target bobot harus lebih besar dari bobot awal.")

        result = run_prediction_inference(payload)
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Terjadi kesalahan inferensi: {str(e)}")
