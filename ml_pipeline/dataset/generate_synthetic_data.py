"""
Script Generator Dataset Sintetis Karakteristik Pertumbuhan Sapi Madura
Menggunakan Standard Library Python (Tidak membutuhkan external package tambahan).
Sesuai Matriks Variabel Proposal Tugas Akhir: Erico Febriyan (2023020100055)
"""

import os
import csv
import math
import random

def generate_madura_cattle_dataset(num_samples: int = 450, seed: int = 42):
    random.seed(seed)

    feed_types = [
        'Konsentrat + Hijauan (Rumput Gajah)',
        'Hijauan Murni (Rumput Lapang)',
        'Jerami Padi Fermentasi + Ampas Tahu',
        'Konsentrat Komersial Tinggi Protein',
        'Silase Jagung + Hijauan Segar',
    ]

    genders = ['Jantan', 'Betina']
    health_conditions = ['Sehat & Aktif', 'Dalam Pemulihan', 'Nafsu Makan Menurun']
    vaccinations = [
        'Sudah Vaksin Lengkap (PMK + Antraks)',
        'Vaksin Sebagian',
        'Belum Divaksin',
    ]

    feed_weights = [0.35, 0.15, 0.20, 0.15, 0.15]
    gender_weights = [0.88, 0.12]
    health_weights = [0.82, 0.12, 0.06]
    vac_weights = [0.60, 0.25, 0.15]
    age_choices = [14, 16, 18, 20, 24, 28, 30]

    feed_boosts = {
        'Konsentrat Komersial Tinggi Protein': 0.38,
        'Konsentrat + Hijauan (Rumput Gajah)': 0.32,
        'Silase Jagung + Hijauan Segar': 0.22,
        'Jerami Padi Fermentasi + Ampas Tahu': 0.15,
        'Hijauan Murni (Rumput Lapang)': 0.04,
    }

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

    records = []

    for i in range(1, num_samples + 1):
        cattle_id = f"MDR-{i:04d}"

        # 1. Bobot awal bakalan sapi Madura (175 - 285 kg)
        initial_weight = round(random.gauss(225.0, 22.0), 1)
        initial_weight = max(175.0, min(285.0, initial_weight))

        # 2. Usia saat masuk feedlot (12 - 36 bulan)
        entry_age = random.choice(age_choices)

        # 3. Jenis Kelamin
        gender = random.choices(genders, weights=gender_weights)[0]

        # 4. Jenis Pakan
        feed_type = random.choices(feed_types, weights=feed_weights)[0]

        # 5. Jumlah pakan harian (kg/hari) ~ 8-11% dari bobot awal
        base_feed_ratio = random.uniform(0.075, 0.11)
        daily_feed = round(initial_weight * base_feed_ratio + random.uniform(-1.0, 1.5), 1)
        daily_feed = max(14.0, min(32.0, daily_feed))

        # 6. Frekuensi pemberian pakan (kali/hari)
        feed_freq = random.choices([2, 3, 4], weights=[0.25, 0.65, 0.10])[0]

        # 7. Kondisi Kesehatan
        health = random.choices(health_conditions, weights=health_weights)[0]

        # 8. Status Vaksinasi
        vac = random.choices(vaccinations, weights=vac_weights)[0]

        # 9. Target Bobot Jual (kg)
        target_weight = round(initial_weight + random.uniform(90.0, 180.0), 1)
        target_weight = max(320.0, min(460.0, target_weight))

        # Perhitungan Ground Truth ADG
        base_adg = 0.42
        feed_boost = feed_boosts[feed_type]
        actual_ratio = daily_feed / initial_weight
        ratio_boost = (actual_ratio - 0.08) * 1.8
        freq_boost = 0.04 if feed_freq >= 3 else 0.0
        gender_boost = 0.08 if gender == 'Jantan' else -0.04
        age_boost = 0.05 if entry_age <= 22 else -0.06
        health_penalty = -0.16 if health == 'Nafsu Makan Menurun' else (-0.08 if health == 'Dalam Pemulihan' else 0.0)
        vac_penalty = -0.05 if vac == 'Belum Divaksin' else 0.0
        noise = random.gauss(0.0, 0.03)

        calculated_adg = base_adg + feed_boost + ratio_boost + freq_boost + gender_boost + age_boost + health_penalty + vac_penalty + noise
        calculated_adg = max(0.28, min(1.10, calculated_adg))
        calculated_adg = round(calculated_adg, 3)

        # 10. Label Target: Durasi Penggemukan sampai Panen (Hari)
        weight_gain_needed = target_weight - initial_weight
        days_to_harvest = int(math.ceil(weight_gain_needed / calculated_adg))

        records.append({
            'cattle_id': cattle_id,
            'bobot_awal': initial_weight,
            'usia_masuk': entry_age,
            'jenis_kelamin': gender,
            'jenis_pakan': feed_type,
            'jumlah_pakan_harian': daily_feed,
            'frekuensi_pakan': feed_freq,
            'kondisi_kesehatan': health,
            'status_vaksinasi': vac,
            'target_bobot': target_weight,
            'adg_kg_per_hari': calculated_adg,
            'durasi_panen_hari': days_to_harvest,
        })

    return records, fieldnames

if __name__ == '__main__':
    output_dir = os.path.dirname(os.path.abspath(__file__))
    output_path = os.path.join(output_dir, 'dataset_sapi_madura_template.csv')

    records, fieldnames = generate_madura_cattle_dataset(num_samples=450)

    with open(output_path, mode='w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(records)

    print(f"Berhasil menghasilkan dataset template Sapi Madura: {output_path}")
    print(f"Total baris data: {len(records)}")
