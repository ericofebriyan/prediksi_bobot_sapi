"""
Pipeline Training & Benchmark Model Regresi Sapi Madura
Tugas Akhir: Erico Febriyan (2023020100055)
Algoritma: XGBoost, Random Forest, GBR, SVR (Baseline), MLP (Baseline)
"""

import os
import sys
import json

# Menambahkan root project dan direktori ml_pipeline ke sys.path agar impor konsisten
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(CURRENT_DIR)
for p in [CURRENT_DIR, PROJECT_ROOT]:
    if p not in sys.path:
        sys.path.insert(0, p)

try:
    import joblib  # type: ignore
    HAS_JOBLIB = True
except ImportError:
    HAS_JOBLIB = False

try:
    import pandas as pd  # type: ignore
    HAS_PANDAS = True
except ImportError:
    HAS_PANDAS = False

try:
    from sklearn.pipeline import Pipeline  # type: ignore
    from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor  # type: ignore
    from sklearn.svm import SVR  # type: ignore
    from sklearn.neural_network import MLPRegressor  # type: ignore
    from sklearn.model_selection import KFold, cross_val_score  # type: ignore
    HAS_SKLEARN = True
except ImportError:
    HAS_SKLEARN = False

try:
    from ml_pipeline.src.preprocessing import prepare_data, build_preprocessor, engineer_features  # type: ignore
    from ml_pipeline.src.evaluate import calculate_metrics, print_metrics_table  # type: ignore
except ImportError:
    from src.preprocessing import prepare_data, build_preprocessor, engineer_features  # type: ignore
    from src.evaluate import calculate_metrics, print_metrics_table  # type: ignore

try:
    from xgboost import XGBRegressor  # type: ignore
    HAS_XGBOOST = True
except ImportError:
    HAS_XGBOOST = False

def run_training_pipeline(dataset_path: str, output_dir: str):
    if not HAS_SKLEARN or not HAS_PANDAS or not HAS_JOBLIB:
        print("[Error] Pustaka data science (scikit-learn, pandas, joblib) belum terpasang.")
        print("Silakan jalankan: pip install -r ml_pipeline/requirements.txt")
        return

    os.makedirs(output_dir, exist_ok=True)
    print("=== MEMULAI PELATIHAN MODEL ENSEMBLE REGRESI SAPI MADURA ===")

    # 1. Menyiapkan Data
    X_train, X_test, y_train, y_test, full_df = prepare_data(dataset_path)
    print(f"[1/4] Data termuat: {len(full_df)} baris. Train: {len(X_train)}, Test: {len(X_test)}")

    preprocessor = build_preprocessor()

    # 2. Definisi 5 Model Kandidat sesuai Blueprint
    models = {
        'Random Forest Regressor': RandomForestRegressor(n_estimators=150, max_depth=12, random_state=42),
        'Gradient Boosting Regressor': GradientBoostingRegressor(n_estimators=150, learning_rate=0.08, max_depth=5, random_state=42),
        'SVR (Baseline)': SVR(C=10.0, epsilon=0.2),
        'MLP Regressor (Baseline)': MLPRegressor(hidden_layer_sizes=(64, 32), max_iter=600, random_state=42),
    }

    if HAS_XGBOOST:
        models['XGBoost Regressor'] = XGBRegressor(n_estimators=150, learning_rate=0.08, max_depth=5, random_state=42)
    else:
        print("[Notice] XGBoost belum terpasang di environment pip, menggunakan model scikit-learn standard.")

    pipelines = {}
    benchmark_results = {}
    best_model_name = None
    best_r2 = -999.0

    print("\n[2/4] Melakukan K-Fold Cross Validation (k=5) & Evaluasi Holdout Set...")
    kf = KFold(n_splits=5, shuffle=True, random_state=42)

    for name, model in models.items():
        pipe = Pipeline(steps=[
            ('preprocessor', preprocessor),
            ('regressor', model)
        ])

        # Cross Validation R2
        cv_scores = cross_val_score(pipe, X_train, y_train, cv=kf, scoring='r2')
        cv_r2_mean = cv_scores.mean()

        # Training pada full training set
        pipe.fit(X_train, y_train)
        y_pred = pipe.predict(X_test)

        metrics = calculate_metrics(y_test, y_pred)
        metrics['CV R2 (5-Fold)'] = round(float(cv_r2_mean), 4)
        benchmark_results[name] = metrics
        pipelines[name] = pipe

        print(f" -> {name}: R2 = {metrics['R2 Score']}, MAE = {metrics['MAE (hari)']} hari")

        if metrics['R2 Score'] > best_r2:
            best_r2 = metrics['R2 Score']
            best_model_name = name

    # 3. Menampilkan Tabel Perbandingan
    print("\n[3/4] Rekapitulasi Metrik Evaluasi Model:")
    print_metrics_table(benchmark_results)
    print(f"🏆 MODEL TERBAIK TERPILIH: {best_model_name} (R² = {best_r2})")

    # 4. Menyimpan Model Terbaik
    best_pipeline = pipelines[best_model_name]
    model_save_path = os.path.join(output_dir, 'best_model_pipeline.joblib')
    joblib.dump(best_pipeline, model_save_path)
    print(f"[4/4] Model tersimpan di: {model_save_path}")

    # Simpan metadata hasil evaluasi dalam JSON untuk laporan & API
    metadata = {
        'best_model': best_model_name,
        'metrics': benchmark_results[best_model_name],
        'all_models_comparison': benchmark_results,
    }
    with open(os.path.join(output_dir, 'model_metadata.json'), 'w') as f:
        json.dump(metadata, f, indent=2)

    print("\n✅ PELATIHAN & EVALUASI SELESAI DENGAN SUKSES!")

if __name__ == '__main__':
    current_dir = os.path.dirname(os.path.abspath(__file__))
    dataset_file = os.path.join(current_dir, 'dataset', 'dataset_sapi_madura_template.csv')

    # Jika dataset template belum ada, generate otomatis
    if not os.path.exists(dataset_file):
        print("Dataset belum ditemukan, memicu generator dataset...")
        from dataset.generate_synthetic_data import generate_madura_cattle_dataset
        records, fieldnames = generate_madura_cattle_dataset(num_samples=400)
        import csv
        with open(dataset_file, mode='w', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(records)

    exported_dir = os.path.join(current_dir, 'exported_models')
    run_training_pipeline(dataset_file, exported_dir)
