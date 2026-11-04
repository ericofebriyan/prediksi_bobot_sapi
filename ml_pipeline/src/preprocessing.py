import os
import sys

try:
    import numpy as np
    import pandas as pd
    from sklearn.model_selection import train_test_split
    from sklearn.preprocessing import StandardScaler, OneHotEncoder
    from sklearn.compose import ColumnTransformer
    HAS_DEPS = True
except ImportError:
    HAS_DEPS = False

# Daftar fitur sesuai matriks variabel TA
NUMERICAL_FEATURES = [
    'bobot_awal',
    'usia_masuk',
    'jumlah_pakan_harian',
    'frekuensi_pakan',
    'target_bobot',
    'feed_ratio',
    'weight_gain_target',
]

CATEGORICAL_FEATURES = [
    'jenis_kelamin',
    'jenis_pakan',
    'kondisi_kesehatan',
    'status_vaksinasi',
]

def engineer_features(df):
    """Melakukan Feature Engineering sesuai karakteristik pakan sapi Madura."""
    df_copy = df.copy()
    df_copy['feed_ratio'] = df_copy['jumlah_pakan_harian'] / df_copy['bobot_awal']
    df_copy['weight_gain_target'] = df_copy['target_bobot'] - df_copy['bobot_awal']
    return df_copy

def build_preprocessor():
    """Membangun transformer Scikit-Learn untuk pipeline model."""
    if not HAS_DEPS:
        return None
    preprocessor = ColumnTransformer(
        transformers=[
            ('num', StandardScaler(), NUMERICAL_FEATURES),
            ('cat', OneHotEncoder(handle_unknown='ignore', sparse_output=False), CATEGORICAL_FEATURES),
        ]
    )
    return preprocessor

def prepare_data(csv_path: str, test_size: float = 0.2, random_state: int = 42):
    """Membaca CSV, membersihkan data, dan membagi dataset menjadi Train & Test."""
    if not HAS_DEPS:
        raise ImportError("Pustaka pandas dan scikit-learn belum terpasang.")

    df = pd.read_csv(csv_path)
    df = engineer_features(df)

    feature_cols = NUMERICAL_FEATURES + CATEGORICAL_FEATURES
    X = df[feature_cols]

    y_duration = df['durasi_panen_hari']
    y_adg = df['adg_kg_per_hari']

    X_train, X_test, y_train, y_test = train_test_split(
        X, y_duration, test_size=test_size, random_state=random_state
    )

    return X_train, X_test, y_train, y_test, df
