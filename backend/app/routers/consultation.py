from fastapi import APIRouter  # type: ignore

try:
    from app.schemas.prediction_schema import ConsultationMessageRequest, ConsultationMessageResponse
    from app.services.expert_rules import evaluate_cattle_symptoms
except ImportError:
    from ..schemas.prediction_schema import ConsultationMessageRequest, ConsultationMessageResponse
    from ..services.expert_rules import evaluate_cattle_symptoms

router = APIRouter(prefix="/consultation", tags=["Konsultasi Dokter Hewan"])

@router.post("/chat", response_model=ConsultationMessageResponse)
def consult_veterinary(payload: ConsultationMessageRequest):
    """
    Endpoint Sistem Pakar Konsultasi Medis Sapi:
    Menganalisis gejala yang dikirimkan peternak dan memberikan diagnosa awal serta SOP pertolongan pertama.
    """
    response = evaluate_cattle_symptoms(payload)
    return response

@router.get("/guidelines")
def get_guidelines():
    """Mengambil panduan standar SOP penggemukan dan nutrisi Sapi Madura."""
    return {
        "title": "Pedoman Penggemukan dan Nutrisi Sapi Madura (Balitbangtan & Dinas Peternakan Jatim)",
        "feed_recommendations": [
            "Pemberian pakan konsentrat (1-2% dari bobot badan) dan hijauan (8-10% dari bobot badan)",
            "Pemberian air minum bersih ad-libitum (tersedia terus menerus)",
            "Sanitasi kandang secara berkala untuk meminimalkan transmisi lalat dan parasit",
        ],
        "vaccination_schedule": [
            "Vaksin PMK Dosis 1: Bulan ke-1 kedatangan",
            "Vaksin PMK Booster: 4-5 minggu setelah dosis 1",
            "Obat cacing (Albendazole): Setiap 3-4 bulan",
        ]
    }
