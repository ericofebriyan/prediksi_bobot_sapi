import '../../features/prediction/models/cattle_model.dart';
import '../../features/prediction/models/prediction_result_model.dart';

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

  static String formatIndoDate(DateTime date) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Memperbarui data prediksi AI pada subjek ternak ketika slider atau inferensi dijalankan ulang.
  CattleTestData withPrediction(PredictionResultModel result) {
    final xgbD = result.xgboostDays ?? result.daysToHarvest;
    final xgbA = result.xgboostAdg ?? result.predictedADG;
    final lgbmD = result.lightgbmDays ?? result.daysToHarvest;
    final lgbmA = result.lightgbmAdg ?? result.predictedADG;
    final rfD = result.rfDays ?? result.daysToHarvest;
    final rfA = result.rfAdg ?? result.predictedADG;

    return CattleTestData(
      id: id,
      name: name,
      tag: tag,
      fullName: fullName,
      ageString: ageString,
      ageMonths: ageMonths,
      gender: gender,
      qualityBadge: qualityBadge,
      breedDescription: breedDescription,
      imagePath: imagePath,
      initialWeight: initialWeight,
      currentWeight: currentWeight,
      targetWeight: result.targetWeight,
      adg: result.predictedADG,
      harvestDays: result.daysToHarvest,
      harvestDateString: 'Panen ~${result.daysToHarvest} hari lagi',
      progressPercent: ((currentWeight / result.targetWeight) * 100).clamp(0.0, 100.0),
      feedlotStatus: feedlotStatus,
      feedType: feedType,
      dailyFeedAmount: dailyFeedAmount,
      feedFrequency: feedFrequency,
      vaccination: vaccination,
      cycleDays: cycleDays,
      initialLiveWeight: initialLiveWeight,
      initialPricePerKg: initialPricePerKg,
      purchasePrice: purchasePrice,
      dailyFeedCost: dailyFeedCost,
      totalFeedCost: totalFeedCost,
      medicalCost: medicalCost,
      totalProductionCost: totalProductionCost,
      estimatedHarvestWeight: result.targetWeight,
      sellingPricePerKg: sellingPricePerKg,
      estimatedRevenue: result.targetWeight * sellingPricePerKg,
      netProfit: (result.targetWeight * sellingPricePerKg) - totalProductionCost,
      roiPercent: totalProductionCost > 0
          ? (((result.targetWeight * sellingPricePerKg) - totalProductionCost) / totalProductionCost) * 100
          : 0,
      bepString: bepString,
      bepMinWeight: bepMinWeight,
      fcrScore: fcrScore,
      fcrCategory: fcrCategory,
      predictedWeight: double.parse((result.targetWeight + 1.2).toStringAsFixed(1)),
      predictedAdg: result.predictedADG,
      predictedDays: result.daysToHarvest,
      predictedHarvestDate: formatIndoDate(result.estimatedHarvestDate),
      xgboostDays: xgbD,
      xgboostWeight: double.parse((currentWeight + (xgbA * xgbD)).toStringAsFixed(1)),
      xgboostAdg: xgbA,
      lightgbmDays: lgbmD,
      lightgbmWeight: double.parse((currentWeight + (lgbmA * lgbmD)).toStringAsFixed(1)),
      lightgbmAdg: lgbmA,
      rfDays: rfD,
      rfWeight: double.parse((currentWeight + (rfA * rfD)).toStringAsFixed(1)),
      rfAdg: rfA,
      medicalBreedTitle: medicalBreedTitle,
      medicalDate: medicalDate,
      medicalLocation: medicalLocation,
      medicalTreatmentTitle: medicalTreatmentTitle,
      medicalTreatmentDose: medicalTreatmentDose,
      medicalNextBooster: medicalNextBooster,
    );
  }

  /// Mengubah input CattleModel baru (dari form / SQLite) menjadi CattleTestData lengkap siap tampil.
  factory CattleTestData.fromCattleModel(
    CattleModel cattle, {
    PredictionResultModel? prediction,
  }) {
    final normalizedTag = cattle.tagNumber.startsWith('#') ? cattle.tagNumber : '#${cattle.tagNumber}';
    final cleanTag = normalizedTag.replaceAll('#', '');
    final shortName = cattle.name.replaceFirst(RegExp(r'^Sapi\s+', caseSensitive: false), '');
    final displayFullName = '$cleanTag ($shortName)';
    final ageYrs = (cattle.entryAgeMonths / 12.0).toStringAsFixed(1);

    final adgVal = prediction?.predictedADG ?? 0.72;
    final daysVal = prediction?.daysToHarvest ??
        ((cattle.targetWeight - cattle.initialWeight).clamp(10.0, 500.0) / adgVal).ceil();
    final harvestDateStr = prediction != null
        ? formatIndoDate(prediction.estimatedHarvestDate)
        : formatIndoDate(DateTime.now().add(Duration(days: daysVal)));

    const priceBuyPerKg = 52000.0;
    const priceSellPerKg = 58500.0;
    final purchaseCost = cattle.initialWeight * priceBuyPerKg;
    final dailyFeedCostVal = cattle.dailyFeedAmount * 2200.0;
    final totalFeedCostVal = dailyFeedCostVal * daysVal;
    const medCostVal = 300000.0;
    final hppVal = purchaseCost + totalFeedCostVal + medCostVal;
    final estRev = cattle.targetWeight * priceSellPerKg;
    final estProfit = estRev - hppVal;
    final estRoi = hppVal > 0 ? (estProfit / hppVal) * 100 : 0.0;

    final xgbD = prediction?.xgboostDays ?? (daysVal - 2).clamp(3, 400);
    final xgbA = prediction?.xgboostAdg ?? double.parse((adgVal * 1.03).toStringAsFixed(2));
    final lgbmD = prediction?.lightgbmDays ?? daysVal;
    final lgbmA = prediction?.lightgbmAdg ?? adgVal;
    final rfD = prediction?.rfDays ?? daysVal + 3;
    final rfA = prediction?.rfAdg ?? double.parse((adgVal * 0.94).toStringAsFixed(2));

    return CattleTestData(
      id: (cattle.id ?? DateTime.now().millisecondsSinceEpoch).toString(),
      name: cattle.name,
      tag: normalizedTag,
      fullName: displayFullName,
      ageString: '$ageYrs Thn',
      ageMonths: cattle.entryAgeMonths,
      gender: cattle.gender,
      qualityBadge: cattle.gender == 'Jantan' ? 'Jantan Baru' : 'Betina Baru',
      breedDescription: 'Sapi Madura Input Baru • Usia ${cattle.entryAgeMonths} Bulan',
      imagePath: 'assets/images/sapi_bima.jpg',
      initialWeight: cattle.initialWeight,
      currentWeight: cattle.initialWeight,
      targetWeight: cattle.targetWeight,
      adg: adgVal,
      harvestDays: daysVal,
      harvestDateString: 'Panen ~$daysVal hari lagi',
      progressPercent: ((cattle.initialWeight / cattle.targetWeight) * 100).clamp(0.0, 100.0),
      feedlotStatus: cattle.healthCondition,
      feedType: cattle.feedType,
      dailyFeedAmount: cattle.dailyFeedAmount,
      feedFrequency: cattle.feedFrequency,
      vaccination: cattle.vaccinationStatus,
      cycleDays: daysVal,
      initialLiveWeight: cattle.initialWeight,
      initialPricePerKg: priceBuyPerKg,
      purchasePrice: purchaseCost,
      dailyFeedCost: dailyFeedCostVal,
      totalFeedCost: totalFeedCostVal,
      medicalCost: medCostVal,
      totalProductionCost: hppVal,
      estimatedHarvestWeight: cattle.targetWeight,
      sellingPricePerKg: priceSellPerKg,
      estimatedRevenue: estRev,
      netProfit: estProfit,
      roiPercent: double.parse(estRoi.toStringAsFixed(1)),
      bepString: 'Rp ${(hppVal / 1000000).toStringAsFixed(2)}M',
      bepMinWeight: double.parse((hppVal / priceSellPerKg).toStringAsFixed(0)),
      fcrScore: double.parse((cattle.dailyFeedAmount / adgVal * 0.65).clamp(5.5, 11.0).toStringAsFixed(1)),
      fcrCategory: 'Efisien & Terukur',
      predictedWeight: double.parse((cattle.targetWeight + 1.0).toStringAsFixed(1)),
      predictedAdg: adgVal,
      predictedDays: daysVal,
      predictedHarvestDate: harvestDateStr,
      xgboostDays: xgbD,
      xgboostWeight: double.parse((cattle.initialWeight + (xgbA * xgbD)).toStringAsFixed(1)),
      xgboostAdg: xgbA,
      lightgbmDays: lgbmD,
      lightgbmWeight: double.parse((cattle.initialWeight + (lgbmA * lgbmD)).toStringAsFixed(1)),
      lightgbmAdg: lgbmA,
      rfDays: rfD,
      rfWeight: double.parse((cattle.initialWeight + (rfA * rfD)).toStringAsFixed(1)),
      rfAdg: rfA,
      medicalBreedTitle: 'Sapi Madura ($cleanTag)',
      medicalDate: formatIndoDate(DateTime.now()),
      medicalLocation: 'Bobot Awal: ${cattle.initialWeight.toInt()} kg • Kandang Peternak',
      medicalTreatmentTitle: 'Pemeriksaan Awal & Pencatatan',
      medicalTreatmentDose: 'Status: ${cattle.healthCondition} • Vaksin: ${cattle.vaccinationStatus}',
      medicalNextBooster: formatIndoDate(DateTime.now().add(const Duration(days: 90))),
    );
  }
}

