import sys

try:
    import numpy as np
    from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
    HAS_METRICS_LIB = True
except ImportError:
    HAS_METRICS_LIB = False

def calculate_metrics(y_true, y_pred) -> dict:
    """
    Menghitung 4 metrik regresi sesuai blueprint penelitian Tugas Akhir:
    - Mean Absolute Error (MAE)
    - Root Mean Squared Error (RMSE)
    - Koefisien Determinasi (R-squared / R2)
    - Mean Absolute Percentage Error (MAPE)
    """
    if not HAS_METRICS_LIB:
        return {'MAE (hari)': 0.0, 'RMSE (hari)': 0.0, 'R2 Score': 0.0, 'MAPE (%)': 0.0}

    y_true_arr = np.array(y_true)
    y_pred_arr = np.array(y_pred)

    mae = mean_absolute_error(y_true_arr, y_pred_arr)
    rmse = np.sqrt(mean_squared_error(y_true_arr, y_pred_arr))
    r2 = r2_score(y_true_arr, y_pred_arr)

    non_zero_mask = y_true_arr != 0
    mape = np.mean(np.abs((y_true_arr[non_zero_mask] - y_pred_arr[non_zero_mask]) / y_true_arr[non_zero_mask])) * 100.0

    return {
        'MAE (hari)': round(float(mae), 3),
        'RMSE (hari)': round(float(rmse), 3),
        'R2 Score': round(float(r2), 4),
        'MAPE (%)': round(float(mape), 2),
    }

def print_metrics_table(results: dict):
    """Menampilkan tabel perbandingan metrik seluruh model kandidat."""
    print("\n" + "=" * 70)
    print(f"{'Model':<30} | {'MAE':<9} | {'RMSE':<9} | {'R²':<8} | {'MAPE':<8}")
    print("-" * 70)
    for model_name, metrics in results.items():
        print(f"{model_name:<30} | {metrics['MAE (hari)']:<9} | {metrics['RMSE (hari)']:<9} | {metrics['R2 Score']:<8} | {metrics['MAPE (%)']:<8}%")
    print("=" * 70 + "\n")
