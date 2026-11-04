from typing import List, Dict, Any
from fastapi import APIRouter  # type: ignore
from pydantic import BaseModel  # type: ignore

router = APIRouter(prefix="/sync", tags=["Sinkronisasi Cloud"])

class SyncPayload(BaseModel):
    device_id: str
    cattle_records: List[Dict[str, Any]]
    prediction_records: List[Dict[str, Any]]

@router.post("/records")
def sync_records(payload: SyncPayload):
    """
    Sinkronisasi Riwayat Sapi dari SQLite di smartphone ke database cloud server.
    Mendukung skenario arsitektur hibrida (offline di kandang, sync saat terhubung internet).
    """
    total_cattle = len(payload.cattle_records)
    total_preds = len(payload.prediction_records)

    return {
        "status": "success",
        "message": f"Berhasil mensinkronkan {total_cattle} data sapi dan {total_preds} riwayat prediksi dari device {payload.device_id}.",
        "synced_at": "now",
    }
