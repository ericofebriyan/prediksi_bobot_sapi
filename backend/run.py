import os
import sys

# Menambahkan direktori backend ke sys.path
BACKEND_DIR = os.path.dirname(os.path.abspath(__file__))
if BACKEND_DIR not in sys.path:
    sys.path.insert(0, BACKEND_DIR)

import uvicorn  # type: ignore

if __name__ == "__main__":
    print("Menjalankan server FastAPI SapiMadura AI...")
    print("Akses dokumentasi Swagger UI di: http://127.0.0.1:8000/docs")
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)
