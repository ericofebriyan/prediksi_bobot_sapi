class CattleTestData {
  final String id;
  final String name;
  final String tag;
  final String fullName; // e.g. "MD-042 (Bima)"
  final String ageString;
  final int ageMonths;
  final String gender;
  final String qualityBadge; // "Jantan Unggul"
  final String breedDescription; // "Keturunan Sonok Super • Usia 22 Bulan"
  final String imagePath;
  final double initialWeight;
  final double currentWeight;
  final double targetWeight;
  final double adg;
  final int harvestDays;
  final String harvestDateString;
  final double progressPercent;
  final String feedlotStatus; // "Sehat Prima"
  final String feedType;
  final double dailyFeedAmount;
  final int feedFrequency;
  final String vaccination;

  // Modul Finansial & Valuasi
  final int cycleDays;
  final double initialLiveWeight;
  final double initialPricePerKg;
  final double purchasePrice; // Modal Bakalan Awal
  final double dailyFeedCost;
  final double totalFeedCost;
  final double medicalCost;
  final double totalProductionCost; // HPP
  final double estimatedHarvestWeight;
  final double sellingPricePerKg;
  final double estimatedRevenue; // Estimasi Jual Panen
  final double netProfit;
  final double roiPercent;
  final String bepString;
  final double bepMinWeight;
  final double fcrScore;
  final String fcrCategory;

  // Modul Prediksi AI Ensemble
  final double predictedWeight;
  final double predictedAdg;
  final int predictedDays;
  final String predictedHarvestDate;
  final int xgboostDays;
  final double xgboostWeight;
  final double xgboostAdg;
  final int lightgbmDays;
  final double lightgbmWeight;
  final double lightgbmAdg;
  final int rfDays;
  final double rfWeight;
  final double rfAdg;

  // Rekam Medis Terakhir
  final String medicalBreedTitle;
  final String medicalDate;
  final String medicalLocation;
  final String medicalTreatmentTitle;
  final String medicalTreatmentDose;
  final String medicalNextBooster;

  const CattleTestData({
    required this.id,
    required this.name,
    required this.tag,
    required this.fullName,
    required this.ageString,
    required this.ageMonths,
    required this.gender,
    required this.qualityBadge,
    required this.breedDescription,
    required this.imagePath,
    required this.initialWeight,
    required this.currentWeight,
    required this.targetWeight,
    required this.adg,
    required this.harvestDays,
    required this.harvestDateString,
    required this.progressPercent,
    required this.feedlotStatus,
    required this.feedType,
    required this.dailyFeedAmount,
    required this.feedFrequency,
    required this.vaccination,
    required this.cycleDays,
    required this.initialLiveWeight,
    required this.initialPricePerKg,
    required this.purchasePrice,
    required this.dailyFeedCost,
    required this.totalFeedCost,
    required this.medicalCost,
    required this.totalProductionCost,
    required this.estimatedHarvestWeight,
    required this.sellingPricePerKg,
    required this.estimatedRevenue,
    required this.netProfit,
    required this.roiPercent,
    required this.bepString,
    required this.bepMinWeight,
    required this.fcrScore,
    required this.fcrCategory,
    required this.predictedWeight,
    required this.predictedAdg,
    required this.predictedDays,
    required this.predictedHarvestDate,
    required this.xgboostDays,
    required this.xgboostWeight,
    required this.xgboostAdg,
    required this.lightgbmDays,
    required this.lightgbmWeight,
    required this.lightgbmAdg,
    required this.rfDays,
    required this.rfWeight,
    required this.rfAdg,
    required this.medicalBreedTitle,
    required this.medicalDate,
    required this.medicalLocation,
    required this.medicalTreatmentTitle,
    required this.medicalTreatmentDose,
    required this.medicalNextBooster,
  });

  // DATA UJI COBA 1: Sapi Bima (MD-042) Sesuai Figma
  static const CattleTestData sapiBima = CattleTestData(
    id: '1',
    name: 'Sapi Bima',
    tag: '#MD-042',
    fullName: 'MD-042 (Bima)',
    ageString: '2.1 Thn',
    ageMonths: 22,
    gender: 'Jantan',
    qualityBadge: 'Jantan Unggul',
    breedDescription: 'Keturunan Sonok Super • Usia 22 Bulan',
    imagePath: 'assets/images/sapi_bima.jpg',
    initialWeight: 280,
    currentWeight: 340,
    targetWeight: 380,
    adg: 0.78,
    harvestDays: 48,
    harvestDateString: 'Panen ~48 hari lagi',
    progressPercent: 89.4,
    feedlotStatus: 'Sehat Prima',
    feedType: 'Konsentrat Dedak Padi (45%) + Jerami Jagung Fermentasi (35%) + Ampas Tahu Basah (20%)',
    dailyFeedAmount: 10.5,
    feedFrequency: 3,
    vaccination: 'Vaksin PMK 2',
    // Finansial
    cycleDays: 120,
    initialLiveWeight: 280,
    initialPricePerKg: 52000,
    purchasePrice: 14560000,
    dailyFeedCost: 22000,
    totalFeedCost: 2640000,
    medicalCost: 350000,
    totalProductionCost: 17550000,
    estimatedHarvestWeight: 382,
    sellingPricePerKg: 58500,
    estimatedRevenue: 22400000,
    netProfit: 4850000,
    roiPercent: 28.4,
    bepString: 'Rp 18.25M',
    bepMinWeight: 312,
    fcrScore: 7.2,
    fcrCategory: 'Efisien & Menguntungkan',
    // Prediksi AI
    predictedWeight: 382.4,
    predictedAdg: 0.88,
    predictedDays: 48,
    predictedHarvestDate: '15 Juli 2026',
    xgboostDays: 47,
    xgboostWeight: 383.0,
    xgboostAdg: 0.91,
    lightgbmDays: 49,
    lightgbmWeight: 381.5,
    lightgbmAdg: 0.85,
    rfDays: 50,
    rfWeight: 382.0,
    rfAdg: 0.84,
    medicalBreedTitle: 'Sapi Madura Sonok Super',
    medicalDate: '10 Mei 2025',
    medicalLocation: 'Bobot Terkini: 418 kg • Kandang A-3 Pasean',
    medicalTreatmentTitle: 'Vitamin B-Kompleks & Obat Cacing...',
    medicalTreatmentDose: 'Dosis: 15ml injeksi IM + 2 bolus oral • Pelaksana: drh. Ahmad Fauzi',
    medicalNextBooster: '10 Agustus 2026',
  );

  // DATA UJI COBA 2: Sapi Arjuna (MD-039) Sesuai Figma
  static const CattleTestData sapiArjuna = CattleTestData(
    id: '2',
    name: 'Sapi Arjuna',
    tag: '#MD-039',
    fullName: 'MD-039 (Arjuna)',
    ageString: '2.4 Thn',
    ageMonths: 28,
    gender: 'Jantan',
    qualityBadge: 'Jantan Super',
    breedDescription: 'Sapi Jantan Madura • Usia 28 Bulan',
    imagePath: 'assets/images/sapi_arjuna.jpg',
    initialWeight: 295,
    currentWeight: 368,
    targetWeight: 375,
    adg: 0.65,
    harvestDays: 11,
    harvestDateString: '11 hari lagi',
    progressPercent: 98.1,
    feedlotStatus: 'Mendekati Target',
    feedType: 'Konsentrat Komersial (50%) + Silase Jagung (30%) + Ampas Tahu (20%)',
    dailyFeedAmount: 11.0,
    feedFrequency: 3,
    vaccination: 'Vaksin Lengkap (PMK + Antraks)',
    // Finansial
    cycleDays: 100,
    initialLiveWeight: 295,
    initialPricePerKg: 52000,
    purchasePrice: 15340000,
    dailyFeedCost: 22000,
    totalFeedCost: 2200000,
    medicalCost: 350000,
    totalProductionCost: 17890000,
    estimatedHarvestWeight: 375,
    sellingPricePerKg: 58500,
    estimatedRevenue: 21937500,
    netProfit: 4047500,
    roiPercent: 22.6,
    bepString: 'Rp 18.50M',
    bepMinWeight: 306,
    fcrScore: 7.4,
    fcrCategory: 'Efisien & Menguntungkan',
    // Prediksi AI
    predictedWeight: 375.2,
    predictedAdg: 0.65,
    predictedDays: 11,
    predictedHarvestDate: '26 Mei 2026',
    xgboostDays: 10,
    xgboostWeight: 375.5,
    xgboostAdg: 0.68,
    lightgbmDays: 11,
    lightgbmWeight: 375.0,
    lightgbmAdg: 0.65,
    rfDays: 12,
    rfWeight: 375.1,
    rfAdg: 0.63,
    medicalBreedTitle: 'Sapi Jantan Madura Feedlot',
    medicalDate: '18 April 2025',
    medicalLocation: 'Bobot Terkini: 368 kg • Kandang B-1 Pasean',
    medicalTreatmentTitle: 'Vaksinasi Booster PMK & Antiparasit',
    medicalTreatmentDose: 'Dosis: 3ml injeksi SC • Pelaksana: drh. Siti Nurhaliza',
    medicalNextBooster: '24 November 2026',
  );

  static const List<CattleTestData> testList = [sapiBima, sapiArjuna];
}

