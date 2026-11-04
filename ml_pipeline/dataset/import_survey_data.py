"""
Skrip Validator & Converter Data Survei Lapangan Sapi Madura
Tugas Akhir: Erico Febriyan (2023020100055)
Fungsi: Membaca file survei lapangan hasil wawancara/penimbangan,
memvalidasi nilai, dan mengonversi menjadi dataset latih model ML.
"""

import os
import csv
import math

def validate_and_convert_survey(input_csv: str, output_csv: str):
    if not os.path.exists(input_csv):
        print(f"[Error] File input tidak ditemukan: {input_csv}")
        return

    valid_rows = []
    errors = []

    valid_feeds = [
        'Konsentrat + Hijauan (Rumput Gajah)',
        'Hijauan Murni (Rumput Lapang)',
        'Jerami Padi Fermentasi + Ampas Tahu',
        'Konsentrat Komersial Tinggi Protein',
        'Silase Jagung + Hijauan Segar',
    ]

    with open(input_csv, mode='r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for idx, row in enumerate(reader, start=2):
            tag = row.get('tag_sapi', f'MDR-{idx}').strip()
            try:
                bobot_awal = float(row['bobot_awal_kg'])
                usia = int(row['usia_masuk_bulan'])
                gender = row['jenis_kelamin'].strip()
                pakan = row['jenis_pakan_dominan'].strip()
                jumlah_pakan = float(row['jumlah_pakan_kg_hari'])
                frekuensi = int(row['frekuensi_pakan_hari'])
                kesehatan = row['kondisi_kesehatan'].strip()
                vaksin = row['status_vaksinasi'].strip()
                bobot_akhir = float(row['bobot_akhir_kg'])

                # Validasi logika biologis
                if bobot_akhir <= bobot_awal:
                    errors.append(f"Baris {idx} ({tag}): Bobot akhir ({bobot_akhir}) <= bobot awal ({bobot_awal}).")
                    continue

                if not (100 <= bobot_awal <= 350):
                    errors.append(f"Baris {idx} ({tag}): Bobot awal tidak wajar ({bobot_awal} kg).")
                    continue

                # Perhitungan durasi & ADG jika kolom kosong
                durasi = row.get('durasi_penggemukan_hari', '').strip()
                if durasi and durasi.isdigit():
                    durasi_hari = int(durasi)
                else:
                    durasi_hari = 120 # Default

                adg_val = row.get('adg_riil_kg_hari', '').strip()
                if adg_val:
                    adg = round(float(adg_val), 3)
                else:
                    adg = round((bobot_akhir - bobot_awal) / durasi_hari, 3)

                valid_rows.append({
                    'cattle_id': tag,
                    'bobot_awal': bobot_awal,
                    'usia_masuk': usia,
                    'jenis_kelamin': gender,
                    'jenis_pakan': pakan,
                    'jumlah_pakan_harian': jumlah_pakan,
                    'frekuensi_pakan': frekuensi,
                    'kondisi_kesehatan': kesehatan,
                    'status_vaksinasi': vaksin,
                    'target_bobot': bobot_akhir,
                    'adg_kg_per_hari': adg,
                    'durasi_panen_hari': durasi_hari,
                })
            except Exception as e:
                errors.append(f"Baris {idx} ({tag}): Gagal diproses: {str(e)}")

    if errors:
        print(f"[Peringatan] Ditemukan {len(errors)} anomali data:")
        for err in errors[:5]:
            print(f"  - {err}")
        if len(errors) > 5:
            print(f"  ... dan {len(errors) - 5} data lainnya.")

    if valid_rows:
        fieldnames = [
            'cattle_id',
            'bobot_awal',
            'usia_masuk',
            'jenis_kelamin',
            'jenis_pakan',
            'jumlah_pakan_harian',
            'frekuensi_pakan',
            'kondisi_kesehatan',
            'status_vaksinasi',
            'target_bobot',
            'adg_kg_per_hari',
            'durasi_panen_hari',
        ]
        with open(output_csv, mode='w', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(valid_rows)

        print(f"\n[Sukses] Berhasil memvalidasi {len(valid_rows)} data survei lapangan!")
        print(f"File dataset siap latih tersimpan di: {output_csv}")
    else:
        print("[Error] Tidak ada baris data valid yang dapat disimpan.")

if __name__ == '__main__':
    base_dir = os.path.dirname(os.path.abspath(__file__))
    input_file = os.path.join(base_dir, 'survey_data_collection_template.csv')
    output_file = os.path.join(base_dir, 'dataset_sapi_madura_real.csv')
    validate_and_convert_survey(input_file, output_file)

