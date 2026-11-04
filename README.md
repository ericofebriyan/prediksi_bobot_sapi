# SapiMadura AI - Prediksi Waktu Panen & Konsultasi Dokter Hewan

Aplikasi mobile cerdas berbasis **Flutter** dan **Machine Learning (Ensemble Learning)** untuk peternak penggemukan Sapi Madura (*feedlot/fattening*).

## Struktur Repositori

```text
prediksi_bobot_sapi_madura/
├── mobile/                        # Frontend Flutter Mobile App
│   ├── lib/
│   │   ├── core/                  # Theme, Colors, Formatters, SQLite Database Helper
│   │   │   ├── constants/
│   │   │   ├── database/
│   │   │   ├── theme/
│   │   │   └── utils/
│   │   ├── features/              # Modul Utama Sesuai Blueprint
│   │   │   ├── dashboard/         # Beranda, Quick Action, Riwayat
│   │   │   ├── prediction/        # Form Input 10 Variabel, Kurva ADG (fl_chart)
│   │   │   ├── consultation/      # Expert System Gejala Penyakit & Konsultasi
│   │   │   └── roi_calculator/    # Kalkulator Analisis Finansial & Proyeksi Laba
│   │   └── main.dart              # Entry Point Aplikasi & Provider State
│   ├── test/                      # Unit Test & Widget Test
│   └── pubspec.yaml
├── backend/                       # (Rencana) REST API FastAPI & Sinkronisasi Cloud
└── ml_model/                      # (Rencana) Skrip Training Ensemble & Model ONNX
```

## Fitur Utama Mobile App

1. **Dashboard Peternakan**: Ringkasan data sapi, status mode offline edge, dan navigasi cepat.
2. **Prediksi Waktu Panen (Ensemble Learning)**:
   - Form input 10 variabel sesuai matriks dataset (Bobot awal, usia masuk, jenis pakan, jumlah pakan harian, frekuensi pakan, kondisi kesehatan, status vaksinasi, target bobot).
   - Menghitung Average Daily Gain (ADG) dan estimasi jumlah hari menuju panen.
   - Visualisasi kurva pertumbuhan interaktif menggunakan **`fl_chart`**.
3. **Konsultasi Dokter Hewan (Sistem Pakar)**:
   - Knowledge base penyakit umum Sapi Madura (PMK, cacingan, bloat/timpani, defisiensi mineral) lengkap dengan panduan penanganan darurat.
   - Modul chat online (siap terhubung ke FastAPI).
4. **Kalkulator Finansial (ROI)**:
   - Perhitungan modal beli bakalan, akumulasi pakan harian, vitamin, proyeksi omzet, laba bersih, dan persentase Return on Investment (ROI).
5. **Mode Offline (Edge Computing di Kandang)**:
   - Database lokal menggunakan **SQLite** (`sqflite`), sehingga peternak tetap dapat menginput dan melihat histori penimbangan di area tanpa sinyal.

## Cara Menjalankan Aplikasi Flutter

1. Masuk ke direktori `mobile`:
   ```bash
   cd mobile
   ```

2. Jalankan dependensi:
   ```bash
   flutter pub get
   ```

3. Jalankan aplikasi ke emulator atau smartphone Android fisik:
   ```bash
   flutter run
   ```

4. Menjalankan pengujian:
   ```bash
   flutter test
   ```

