from typing import List, Optional
from pydantic import BaseModel, Field

class PredictionRequest(BaseModel):
    cattle_tag: str = Field(..., example="MDR-001")
    bobot_awal: float = Field(..., gt=50, lt=600, example=220.0, description="Bobot awal (kg)")
    usia_masuk: int = Field(..., gt=6, lt=60, example=18, description="Usia sapi masuk (bulan)")
    jenis_kelamin: str = Field(..., example="Jantan")
    jenis_pakan: str = Field(..., example="Konsentrat + Hijauan (Rumput Gajah)")
    jumlah_pakan_harian: float = Field(..., gt=5, lt=60, example=20.0, description="Pakan harian (kg/hari)")
    frekuensi_pakan: int = Field(..., ge=1, le=5, example=3, description="Frekuensi pakan (kali/hari)")
    kondisi_kesehatan: str = Field(..., example="Sehat & Aktif")
    status_vaksinasi: str = Field(..., example="Sudah Vaksin Lengkap (PMK + Antraks)")
    target_bobot: float = Field(..., gt=100, lt=700, example=380.0, description="Target bobot jual (kg)")

class GrowthCurvePoint(BaseModel):
    day: int
    projected_weight: float

class PredictionResponse(BaseModel):
    cattle_tag: str
    initial_weight: float
    target_weight: float
    predicted_adg: float
    estimated_days_to_harvest: int
    estimated_harvest_date: str
    total_weight_gain_needed: float
    confidence_score: float
    model_algorithm: str
    veterinary_recommendation: str
    growth_curve: List[GrowthCurvePoint]

class ConsultationMessageRequest(BaseModel):
    farmer_name: str = "Peternak Madura"
    cattle_tag: Optional[str] = None
    symptoms: List[str]
    description: str

class ConsultationMessageResponse(BaseModel):
    possible_diagnosis: str
    urgency_level: str
    first_aid_action: str
    nutritional_advice: str
    veterinary_contact: str

