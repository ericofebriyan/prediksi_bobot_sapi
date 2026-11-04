class AppConstants {
  static const String appName = 'SapiMadura AI';
  static const String appSubtitle = 'Prediksi Waktu Panen & Konsultasi Dokter Hewan';
  static const String appVersion = '1.0.0';

  // Opsi Pakan berdasarkan Blueprint TA
  static const List<String> feedTypes = [
    'Konsentrat + Hijauan (Rumput Gajah)',
    'Hijauan Murni (Rumput Lapang)',
    'Jerami Padi Fermentasi + Ampas Tahu',
    'Konsentrat Komersial Tinggi Protein',
    'Silase Jagung + Hijauan Segar',
  ];

  // Opsi Jenis Kelamin Sapi
  static const List<String> genders = [
    'Jantan',
    'Betina',
  ];

  // Opsi Status Kesehatan
  static const List<String> healthConditions = [
    'Sehat & Aktif',
    'Dalam Pemulihan',
    'Nafsu Makan Menurun',
  ];

  // Opsi Status Vaksinasi
  static const List<String> vaccinationStatus = [
    'Sudah Vaksin Lengkap (PMK + Antraks)',
    'Vaksin Sebagian',
    'Belum Divaksin',
  ];

  // Default Average Daily Gain (ADG) dalam kg/hari untuk Sapi Madura
  // Tradisional: 0.3 - 0.5 kg/hari, Feedlot Optimal: 0.7 - 1.0 kg/hari
  static const double minADGTraditional = 0.35;
  static const double optimalADG = 0.85;

  // Standar Harga Estimasi (Bisa disesuaikan di kalkulator ROI)
  static const double defaultPricePerKgLive = 65000.0; // Rp/kg hidup
  static const double defaultFeedCostPerKg = 2500.0; // Rp/kg pakan rata-rata
}

