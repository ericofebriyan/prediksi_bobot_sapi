"""
Pipeline Training, Evaluasi & Ekspor ONNX Model Regresi Ensemble Sapi Madura
Tugas Akhir: M. Erico Febriyan (2023020100055)
Algoritma: Weighted Voting Ensemble (XGBoost 45% + LightGBM 35% + Random Forest 20%)
           beserta Pembanding GBR, SVR, dan MLP
"""

import os
import sys
import json
import shutil

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
    import numpy as np  # type: ignore
    import pandas as pd  # type: ignore
    HAS_PANDAS = True
except ImportError:
    HAS_PANDAS = False

try:
    from sklearn.pipeline import Pipeline  # type: ignore
    from sklearn.ensemble import (  # type: ignore
        RandomForestRegressor,
        GradientBoostingRegressor,
        VotingRegressor,
    )
    from sklearn.svm import SVR  # type: ignore
    from sklearn.neural_network import MLPRegressor  # type: ignore
    from sklearn.model_selection import KFold, cross_val_score  # type: ignore
    HAS_SKLEARN = True
except ImportError:
    HAS_SKLEARN = False

try:
    from ml_pipeline.src.preprocessing import (  # type: ignore
        NUMERICAL_FEATURES,
        CATEGORICAL_FEATURES,
        prepare_data,
        build_preprocessor,
    )
    from ml_pipeline.src.evaluate import calculate_metrics, print_metrics_table  # type: ignore
except ImportError:
    from src.preprocessing import (  # type: ignore
        NUMERICAL_FEATURES,
        CATEGORICAL_FEATURES,
        prepare_data,
        build_preprocessor,
    )
    from src.evaluate import calculate_metrics, print_metrics_table  # type: ignore

try:
    from xgboost import XGBRegressor  # type: ignore
    HAS_XGBOOST = True
except ImportError:
    HAS_XGBOOST = False

try:
    from lightgbm import LGBMRegressor  # type: ignore
    HAS_LIGHTGBM = True
except ImportError:
    HAS_LIGHTGBM = False


def export_pipeline_to_onnx(pipeline: Pipeline, X_sample: pd.DataFrame, onnx_path: str, mobile_assets_dir: str) -> bool:
    """
    Mengonversi pipeline Scikit-Learn / Ensemble ke format ONNX agar dapat
    dijalankan secara offline (Edge AI) di perangkat mobile maupun backend.
    """
    try:
        from skl2onnx import convert_sklearn, update_registered_converter  # type: ignore
        from skl2onnx.common.data_types import FloatTensorType, StringTensorType  # type: ignore
        from skl2onnx.common.shape_calculator import calculate_linear_regressor_output_shapes  # type: ignore
        import onnxruntime as ort  # type: ignore

        if HAS_XGBOOST:
            from onnxmltools.convert.xgboost.operator_converters.XGBoost import convert_xgboost  # type: ignore
            update_registered_converter(
                XGBRegressor,
                "XGBoostXGBRegressor",
                calculate_linear_regressor_output_shapes,
                convert_xgboost,
            )

        if HAS_LIGHTGBM:
            from onnxmltools.convert.lightgbm.operator_converters.LightGbm import convert_lightgbm  # type: ignore
            update_registered_converter(
                LGBMRegressor,
                "LightGbmLGBMRegressor",
                calculate_linear_regressor_output_shapes,
                convert_lightgbm,
            )

        initial_types = [
            (col, FloatTensorType([None, 1])) for col in NUMERICAL_FEATURES
        ] + [
            (col, StringTensorType([None, 1])) for col in CATEGORICAL_FEATURES
        ]

        onnx_model = convert_sklearn(
            pipeline,
            initial_types=initial_types,
            target_opset={"": 15, "ai.onnx.ml": 3},
        )

        with open(onnx_path, "wb") as f:
            f.write(onnx_model.SerializeToString())

        # Verifikasi akurasi inferensi ONNX Runtime vs Python pipeline asli
        sess = ort.InferenceSession(onnx_path, providers=["CPUExecutionProvider"])
        sample_row = X_sample.iloc[:3]
        ort_inputs = {}
        for col in NUMERICAL_FEATURES:
            ort_inputs[col] = sample_row[[col]].to_numpy(dtype=np.float32)
        for col in CATEGORICAL_FEATURES:
            ort_inputs[col] = sample_row[[col]].to_numpy(dtype=str)

        ort_preds = sess.run(None, ort_inputs)[0].flatten()
        py_preds = pipeline.predict(sample_row)
        max_diff = float(np.max(np.abs(ort_preds - py_preds)))

        print(f" -> ONNX tersimpan: {onnx_path} ({os.path.getsize(onnx_path) / 1024:.1f} KB)")
        print(f" -> Verifikasi ONNX Runtime (CPUExecutionProvider) max delta: {max_diff:.6f} hari")

        if os.path.isdir(mobile_assets_dir):
            mobile_onnx_path = os.path.join(mobile_assets_dir, "sapi_madura_ensemble.onnx")
            shutil.copy2(onnx_path, mobile_onnx_path)
            print(f" -> Disalin ke aset mobile: {mobile_onnx_path}")

        return True
    except Exception as exc:
        print(f"[Warning] Konversi ONNX dilewati / gagal: {exc}")
        return False


def run_training_pipeline(dataset_path: str, output_dir: str):
    """Melatih model kandidat + Weighted Ensemble, mengevaluasi metrik, dan mengekspor model."""
    if not HAS_SKLEARN or not HAS_PANDAS or not HAS_JOBLIB:
        print("[Error] Pustaka data science (scikit-learn, pandas, joblib) belum terpasang.")
        print("Silakan jalankan: pip install -r ml_pipeline/requirements.txt")
        return

    os.makedirs(output_dir, exist_ok=True)
    print("=== MEMULAI PELATIHAN MODEL ENSEMBLE REGRESI SAPI MADURA ===")

    # 1. Menyiapkan Data
    X_train, X_test, y_train, y_test, full_df = prepare_data(dataset_path)
    print(f"[1/5] Data termuat: {len(full_df)} baris. Train: {len(X_train)}, Test: {len(X_test)}")

    # 2. Definisi Model Kandidat sesuai Blueprint Proposal & Aplikasi Mobile
    rf_reg = RandomForestRegressor(n_estimators=250, max_depth=16, min_samples_leaf=2, random_state=42)
    gbr_reg = GradientBoostingRegressor(n_estimators=200, learning_rate=0.06, max_depth=4, random_state=42)
    svr_reg = SVR(C=10.0, epsilon=0.2)
    mlp_reg = MLPRegressor(
        hidden_layer_sizes=(64, 32),
        max_iter=1500,
        early_stopping=True,
        validation_fraction=0.15,
        n_iter_no_change=25,
        random_state=42,
    )

    models = {
        "Random Forest Regressor": rf_reg,
        "Gradient Boosting Regressor": gbr_reg,
        "SVR (Baseline)": svr_reg,
        "MLP Regressor (Baseline)": mlp_reg,
    }

    ensemble_estimators = []
    ensemble_weights = []

    if HAS_XGBOOST:
        xgb_reg = XGBRegressor(n_estimators=200, learning_rate=0.05, max_depth=4, subsample=0.9, random_state=42)
        models["XGBoost Regressor"] = xgb_reg
        ensemble_estimators.append(("xgb", XGBRegressor(n_estimators=200, learning_rate=0.05, max_depth=4, subsample=0.9, random_state=42)))
        ensemble_weights.append(0.50)

    if HAS_LIGHTGBM:
        lgbm_reg = LGBMRegressor(n_estimators=200, learning_rate=0.05, max_depth=5, num_leaves=20, min_child_samples=5, random_state=42, verbose=-1)
        models["LightGBM Regressor"] = lgbm_reg
        ensemble_estimators.append(("lgbm", LGBMRegressor(n_estimators=200, learning_rate=0.05, max_depth=5, num_leaves=20, min_child_samples=5, random_state=42, verbose=-1)))
        ensemble_weights.append(0.35)

    # Tambahkan Random Forest ke dalam Ensemble Voting
    ensemble_estimators.append(("rf", RandomForestRegressor(n_estimators=250, max_depth=16, min_samples_leaf=2, random_state=42)))
    if not HAS_XGBOOST and not HAS_LIGHTGBM:
        ensemble_estimators.append(("gbr", GradientBoostingRegressor(n_estimators=200, learning_rate=0.06, max_depth=4, random_state=42)))
        ensemble_weights = [0.5, 0.5]
    elif HAS_XGBOOST and not HAS_LIGHTGBM:
        ensemble_weights = [0.75, 0.25]
    elif not HAS_XGBOOST and HAS_LIGHTGBM:
        ensemble_weights = [0.75, 0.25]
    else:
        ensemble_weights.append(0.15)

    models["Weighted Ensemble (XGB+LGBM+RF)"] = VotingRegressor(
        estimators=ensemble_estimators,
        weights=np.array(ensemble_weights, dtype=np.float64),
    )

    pipelines = {}
    benchmark_results = {}
    best_model_name = None
    best_r2 = -999.0

    print("\n[2/5] Melakukan K-Fold Cross Validation (k=5) & Evaluasi Holdout Set...")
    kf = KFold(n_splits=5, shuffle=True, random_state=42)

    for name, model in models.items():
        pipe = Pipeline(steps=[
            ("preprocessor", build_preprocessor()),
            ("regressor", model),
        ])

        cv_scores = cross_val_score(pipe, X_train, y_train, cv=kf, scoring="r2")
        cv_r2_mean = cv_scores.mean()

        pipe.fit(X_train, y_train)
        y_pred = pipe.predict(X_test)

        metrics = calculate_metrics(y_test, y_pred)
        metrics["CV R2 (5-Fold)"] = round(float(cv_r2_mean), 4)
        benchmark_results[name] = metrics
        pipelines[name] = pipe

        print(f" -> {name}: R2 = {metrics['R2 Score']}, MAE = {metrics['MAE (hari)']} hari, MAPE = {metrics['MAPE (%)']}%")

        if metrics["R2 Score"] > best_r2:
            best_r2 = metrics["R2 Score"]
            best_model_name = name

    # 3. Menampilkan Tabel Perbandingan
    print("\n[3/5] Rekapitulasi Metrik Evaluasi Model:")
    print_metrics_table(benchmark_results)
    print(f"MODEL TERBAIK BERDASARKAN R2 HOLDOUT: {best_model_name} (R2 = {best_r2})")

    # 4. Menyimpan Model Joblib & Metadata
    best_pipeline = pipelines[best_model_name]
    ensemble_pipeline = pipelines["Weighted Ensemble (XGB+LGBM+RF)"]

    best_save_path = os.path.join(output_dir, "best_model_pipeline.joblib")
    ensemble_save_path = os.path.join(output_dir, "sapi_madura_ensemble.joblib")
    joblib.dump(best_pipeline, best_save_path)
    joblib.dump(ensemble_pipeline, ensemble_save_path)
    print(f"[4/5] Model Joblib tersimpan di: {best_save_path}")

    # 5. Ekspor Model Ensemble ke ONNX untuk Mobile Edge AI
    print("\n[5/5] Mengekspor Pipeline Weighted Ensemble ke Format ONNX...")
    onnx_save_path = os.path.join(output_dir, "sapi_madura_ensemble.onnx")
    mobile_models_dir = os.path.join(PROJECT_ROOT, "mobile", "assets", "models")
    onnx_ok = export_pipeline_to_onnx(ensemble_pipeline, X_test, onnx_save_path, mobile_models_dir)

    metadata = {
        "best_model": best_model_name,
        "ensemble_weights": {
            est_name: w for (est_name, _), w in zip(ensemble_estimators, ensemble_weights)
        },
        "metrics": benchmark_results[best_model_name],
        "ensemble_metrics": benchmark_results["Weighted Ensemble (XGB+LGBM+RF)"],
        "all_models_comparison": benchmark_results,
        "onnx_exported": onnx_ok,
        "features": {
            "numerical": NUMERICAL_FEATURES,
            "categorical": CATEGORICAL_FEATURES,
        },
    }
    with open(os.path.join(output_dir, "model_metadata.json"), "w", encoding="utf-8") as f:
        json.dump(metadata, f, indent=2)

    print("\nPELATIHAN, EVALUASI, & EKSPOR SELESAI DENGAN SUKSES!")


if __name__ == "__main__":
    current_dir = os.path.dirname(os.path.abspath(__file__))
    dataset_file = os.path.join(current_dir, "dataset", "dataset_sapi_madura_template.csv")

    if not os.path.exists(dataset_file):
        print("Dataset belum ditemukan, memicu generator dataset...")
        from dataset.generate_synthetic_data import generate_madura_cattle_dataset
        records, fieldnames = generate_madura_cattle_dataset(num_samples=400)
        import csv
        with open(dataset_file, mode="w", newline="", encoding="utf-8") as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(records)

    exported_dir = os.path.join(current_dir, "exported_models")
    run_training_pipeline(dataset_file, exported_dir)
