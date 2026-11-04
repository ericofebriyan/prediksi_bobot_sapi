# INSTRUMEN SURVEI DATA PRIMER PENGGEMUKAN SAPI MADURA

**Peneliti:** Erico Febriyan  
**NIM:** 2023020100055  
**Program Studi:** S1 Teknik Informatika / Cyber Security (Semester 7)  
**Judul Tugas Akhir:** *Penerapan Algoritma Ensemble Learning untuk Prediksi Waktu Panen Sapi Madura pada Aplikasi Konsultasi Dokter Hewan*  
**Lokasi Survei:** Sentra Peternakan Rakyat & Feedlot di Pulau Madura (Bangkalan, Sampang, Pamekasan, Sumenep)

---

## 📋 BAGIAN 1: Lembar Observasi & Wawancara Lapangan (Siap Cetak A4)

*(Gunakan lembar ini di clipboard saat berkunjung ke kandang peternak atau pasar hewan)*

### Identitas Peternak / Responden

| Informasi | Keterangan Isian |
| :--- | :--- |
| **Nama Pemilik / Peternak** | : ............................................................................................ |
| **Nomor Telepon / WhatsApp** | : ............................................................................................ |
| **Lokasi Kandang** | : Dusun/Desa: ............................, Kec: ............................, Kab: ............................ |
| **Skala Usaha Penggemukan** | : [  ] Rakyat (1–5 ekor) &nbsp;&nbsp;&nbsp; [  ] Menengah (6–15 ekor) &nbsp;&nbsp;&nbsp; [  ] Feedlot Komersial (>15 ekor) |
| **Tipe Kandang** | : [  ] Panggung Kayu/Bambu &nbsp;&nbsp;&nbsp; [  ] Lantai Semen Terbuka &nbsp;&nbsp;&nbsp; [  ] Kandang Individual/Sekat |
| **Metode Pengukuran Bobot** | : [  ] Timbangan Lantai Digital &nbsp;&nbsp;&nbsp; [  ] Pita Ukur Ternak (Rondo/Winter) &nbsp;&nbsp;&nbsp; [  ] Pita Ukur Schoorl |

---

### Tabel Lembar Pengukuran Sapi (Per Ekor)

Isi setiap baris untuk satu ekor sapi Madura yang sedang atau telah selesai masa penggemukan:

| No | Tag / ID Sapi | Usia Masuk *(Bulan)* | Kelamin *(J / B)* | Bobot Awal *(kg)* | Lingkar Dada *(cm)* | Jenis Pakan Utama | Porsi Pakan *(kg/hari)* | Frek. Pakan *(x/hari)* | Kondisi Kesehatan | Status Vaksin *(PMK/dll)* | Target / Bobot Akhir *(kg)* | Durasi Panen *(Hari)* |
| :-: | :--- | :-: | :-: | :-: | :-: | :--- | :-: | :-: | :--- | :--- | :-: | :-: |
| **Contoh** | *MDR-01* | *18 bln* | *J* | *220 kg* | *148 cm* | *Konsentrat + Rumput* | *20 kg* | *3* | *Sehat & Aktif* | *Lengkap* | *360 kg* | *140 hari* |
| **1** | | | | | | | | | | | | |
| **2** | | | | | | | | | | | | |
| **3** | | | | | | | | | | | | |
| **4** | | | | | | | | | | | | |
| **5** | | | | | | | | | | | | |
| **6** | | | | | | | | | | | | |
| **7** | | | | | | | | | | | | |
| **8** | | | | | | | | | | | | |
| **9** | | | | | | | | | | | | |
| **10** | | | | | | | | | | | | |

*(Lembar ini dapat difotokopi sebanyak 20–50 lembar untuk mencatat 200–500 ekor sapi)*

---

## 📏 BAGIAN 2: SOP Praktis Pengukuran di Kandang Peternak

### 1. Menentukan Usia Sapi Masuk (Jika Peternak Lupa Tanggal Lahir)
Gunakan metode inspeksi **gigi seri permanen (Poel)** pada rahang bawah sapi:
* **Belum Poel (Gigi Susu Semua):** Usia $< 1.5\text{ tahun}$ ($< 18\text{ bulan}$).
* **Poel 1 Pasang (2 Gigi Seri Tetap Tumbuh):** Usia $\approx 1.5 - 2\text{ tahun}$ ($18 - 24\text{ bulan}$). *(Usia bakalan ideal Madura)*.
* **Poel 2 Pasang (4 Gigi Seri Tetap):** Usia $\approx 2.5 - 3\text{ tahun}$ ($30 - 36\text{ bulan}$).
* **Poel 3 Pasang (6 Gigi Seri Tetap):** Usia $\approx 3.5 - 4\text{ tahun}$ ($42 - 48\text{ bulan}$).

### 2. Menghitung Bobot Sapi Tanpa Timbangan Digital (Rumus Ilmiah)
Jika peternak tidak memiliki timbangan lantai digital, lilitkan pita ukur tepat di belakang punuk/kaki depan melingkari dada (*Girth*):

$$\text{Rumus Schoorl (Umum Peternakan Jatim):} \quad \text{Bobot (kg)} = \frac{(\text{Lingkar Dada (cm)} + 22)^2}{100}$$

$$\text{Rumus Winter:} \quad \text{Bobot (kg)} = \frac{(\text{Lingkar Dada (cm)})^2 \times \text{Panjang Badan (cm)}}{10815.15}$$

> [!TIP]
> **Pita Ukur Rondo / Weight Tape:**  
> Jika Anda membeli pita ukur sapi di toko peternakan (*cattle weight tape*), pita tersebut sudah otomatis memiliki skala konversi dari cm langsung ke kilogram pada sisi sebaliknya.

### 3. Konversi Takaran Pakan Tradisional Peternak Madura ke Kilogram
* **1 Keranjang / Karung Rumput Lapang Segar:** $\approx 15 - 20\text{ kg}$
* **1 Ikat Besar Rumput Gajah / Kolonjono / Odot:** $\approx 25 - 30\text{ kg}$
* **1 Ember Cat Kecil (5 kg) Konsentrat / Dedak:** $\approx 3.5 - 4.5\text{ kg}$
* **1 Ember Sedang Ampas Tahu Basah:** $\approx 4 - 6\text{ kg}$

---

## 🗂️ BAGIAN 3: Kamus Data (*Data Dictionary*) untuk Input Excel/CSV

Saat menyalin data dari lembar kertas ke file spreadsheet:

| Nama Kolom CSV | Tipe Data | Pilihan Nilai Standar | Keterangan |
| :--- | :--- | :--- | :--- |
| `tag_sapi` | Text | `MDR-001`, `MDR-002`, dst. | Kode unik penanda sapi |
| `usia_masuk_bulan` | Integer | `12` s/d `48` | Usia sapi saat mulai dipelihara (bulan) |
| `jenis_kelamin` | Text | `Jantan` atau `Betina` | Mayoritas penggemukan adalah Jantan |
| `bobot_awal_kg` | Float | `150.0` s/d `300.0` | Bobot saat sapi masuk kandang |
| `jenis_pakan_dominan` | Text | Pilih salah satu: <br>• `Konsentrat + Hijauan (Rumput Gajah)`<br>• `Hijauan Murni (Rumput Lapang)`<br>• `Jerami Padi Fermentasi + Ampas Tahu`<br>• `Konsentrat Komersial Tinggi Protein`<br>• `Silase Jagung + Hijauan Segar` | Komposisi nutrisi harian |
| `jumlah_pakan_kg_hari` | Float | `12.0` s/d `35.0` | Total akumulasi pakan basah per hari |
| `frekuensi_pakan_hari` | Integer | `2`, `3`, atau `4` | Berapa kali peternak memberi makan |
| `kondisi_kesehatan` | Text | • `Sehat & Aktif`<br>• `Dalam Pemulihan`<br>• `Nafsu Makan Menurun` | Kondisi fisik dan kelincahan sapi |
| `status_vaksinasi` | Text | • `Sudah Vaksin Lengkap (PMK + Antraks)`<br>• `Vaksin Sebagian`<br>• `Belum Divaksin` | Catatan vaksinasi dinas/mantri |
| `bobot_akhir_kg` | Float | `300.0` s/d `480.0` | Bobot riil saat panen atau penimbangan akhir |
| `durasi_penggemukan_hari` | Integer | `60` s/d `240` | Total hari sapi digemukkan |
| `adg_riil_kg_hari` | Float | `0.30` s/d `1.20` | Pertambahan bobot per hari: $\frac{\text{Bobot Akhir} - \text{Bobot Awal}}{\text{Durasi Hari}}$ |

---

## ⚡ BAGIAN 4: Cara Otomasi Impor Data Survei ke Pipeline AI

1. Buka file template CSV di Excel:  
   [`ml_pipeline/dataset/survey_data_collection_template.csv`](file:///d:/M%20ERICO%20FEBRIYAN/semester%207/prediksi_bobot_sapi_madura/ml_pipeline/dataset/survey_data_collection_template.csv)
2. Masukkan data hasil survei lapangan Anda ke baris-baris berikutnya.
3. Jalankan skrip validator otomatis di terminal:
   ```bash
   python ml_pipeline/dataset/import_survey_data.py
   ```
4. Skrip akan otomatis:
   - Memeriksa konsistensi biologis (mencegah salah ketik bobot akhir lebih kecil dari bobot awal).
   - Menghitung nilai ADG riil harian.
   - Menghasilkan file dataset bersih [`dataset_sapi_madura_real.csv`](file:///d:/M%20ERICO%20FEBRIYAN/semester%207/prediksi_bobot_sapi_madura/ml_pipeline/dataset/dataset_sapi_madura_real.csv) yang siap langsung dilatih oleh model Ensemble Learning!

