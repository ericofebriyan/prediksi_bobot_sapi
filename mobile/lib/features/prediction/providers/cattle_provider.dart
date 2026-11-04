import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/database/local_db_helper.dart';
import '../models/cattle_model.dart';
import '../models/prediction_result_model.dart';

class CattleProvider extends ChangeNotifier {
  final LocalDbHelper _dbHelper = LocalDbHelper.instance;

  List<CattleModel> _cattleList = [];
  List<Map<String, dynamic>> _predictionHistory = [];
  bool _isLoading = false;
  PredictionResultModel? _latestResult;

  List<CattleModel> get cattleList => _cattleList;
  List<Map<String, dynamic>> get predictionHistory => _predictionHistory;
  bool get isLoading => _isLoading;
  PredictionResultModel? get latestResult => _latestResult;

  Future<void> init() async {
    await loadCattleList();
    await loadHistory();
  }

  Future<void> loadCattleList() async {
    _isLoading = true;
    notifyListeners();

    try {
      final rows = await _dbHelper.getAllCattle();
      _cattleList = rows.map((e) => CattleModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Error loading cattle list: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadHistory() async {
    try {
      _predictionHistory = await _dbHelper.getPredictionHistory();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading prediction history: $e');
    }
  }

  /// Menghitung prediksi ADG dan waktu panen
  /// Menggunakan logika inferensi empiris Sapi Madura
  /// (Dapat dihubungkan ke ONNX Runtime atau FastAPI REST API)
  Future<PredictionResultModel> predictHarvest({
    required String tagNumber,
    required double initialWeight,
    required int entryAgeMonths,
    required String gender,
    required String feedType,
    required double dailyFeedAmount,
    required int feedFrequency,
    required String healthCondition,
    required String vaccinationStatus,
    required double targetWeight,
  }) async {
    _isLoading = true;
    notifyListeners();

    // Simulasi delay komputasi inferensi ML (Edge AI / ONNX)
    await Future.delayed(const Duration(milliseconds: 600));

    // Base ADG rata-rata sapi Madura (0.45 kg/hari)
    double adg = 0.45;

    // Bobot faktor pakan
    if (feedType.contains('Konsentrat Komersial')) {
      adg += 0.35;
    } else if (feedType.contains('Konsentrat + Hijauan')) {
      adg += 0.28;
    } else if (feedType.contains('Silase Jagung')) {
      adg += 0.20;
    } else if (feedType.contains('Jerami Padi Fermentasi')) {
      adg += 0.12;
    } else {
      // Hijauan Murni
      adg += 0.05;
    }

    // Koreksi rasio jumlah pakan harian
    // Kebutuhan pakan hijauan basah sapi biasanya 8-10% dari bobot badan
    final feedRatio = dailyFeedAmount / initialWeight;
    if (feedRatio >= 0.10) {
      adg += 0.08;
    } else if (feedRatio < 0.06) {
      adg -= 0.10;
    }

    // Koreksi frekuensi pakan
    if (feedFrequency >= 3) {
      adg += 0.04;
    }

    // Koreksi jenis kelamin (Jantan memiliki ADG lebih tinggi)
    if (gender == 'Jantan') {
      adg += 0.07;
    }

    // Koreksi usia (usia muda 12-24 bulan memiliki pertumbuhan lebih cepat)
    if (entryAgeMonths >= 12 && entryAgeMonths <= 24) {
      adg += 0.05;
    } else if (entryAgeMonths > 36) {
      adg -= 0.08;
    }

    // Koreksi kondisi kesehatan & vaksinasi
    if (healthCondition != 'Sehat & Aktif') {
      adg -= 0.18;
    }
    if (vaccinationStatus == 'Belum Divaksin') {
      adg -= 0.05;
    }

    // Pembatasan nilai wajar ADG Sapi Madura (0.25 s/d 1.15 kg/hari)
    adg = adg.clamp(0.25, 1.15);

    final totalGainNeeded = max(0.0, targetWeight - initialWeight);
    final daysToHarvest = (totalGainNeeded / adg).ceil();
    final harvestDate = DateTime.now().add(Duration(days: daysToHarvest));

    // Membuat titik kurva pertumbuhan untuk grafik fl_chart (interval 15-30 hari)
    final List<GrowthPoint> curve = [];
    final steps = 6;
    final stepDays = (daysToHarvest / steps).ceil();

    for (int i = 0; i <= steps; i++) {
      final currentDay = min(daysToHarvest, i * stepDays);
      final currentWeight = initialWeight + (adg * currentDay);
      curve.add(GrowthPoint(
        day: currentDay.toDouble(),
        weight: double.parse(currentWeight.toStringAsFixed(1)),
      ));
    }

    // Rekomendasi ahli nutrisi veteriner
    String recommendation;
    if (adg >= 0.75) {
      recommendation =
          'Program penggemukan sangat optimal! Pertahankan porsi konsentrat dan kebersihan air minum untuk menjaga efisiensi FCR.';
    } else if (adg >= 0.50) {
      recommendation =
          'Pertumbuhan cukup baik. Disarankan menambahkan porsi konsentrat/ampas tahu sebanyak 1-2 kg/hari agar waktu panen lebih singkat.';
    } else {
      recommendation =
          'ADG di bawah rata-rata optimal. Cek kondisi cacingan, sanitasi kandang, dan tingkatkan rasio nutrisi pakan berkualitas tinggi.';
    }

    final result = PredictionResultModel(
      cattleTag: tagNumber,
      initialWeight: initialWeight,
      targetWeight: targetWeight,
      predictedADG: double.parse(adg.toStringAsFixed(2)),
      daysToHarvest: daysToHarvest,
      estimatedHarvestDate: harvestDate,
      totalWeightGain: double.parse(totalGainNeeded.toStringAsFixed(1)),
      growthCurve: curve,
      recommendation: recommendation,
    );

    _latestResult = result;

    // Simpan ke database SQLite offline
    try {
      await _dbHelper.insertPrediction({
        'cattle_tag': tagNumber,
        'initial_weight': initialWeight,
        'target_weight': targetWeight,
        'predicted_adg': result.predictedADG,
        'estimated_days': daysToHarvest,
        'estimated_harvest_date': harvestDate.toIso8601String(),
        'feed_type': feedType,
        'created_at': DateTime.now().toIso8601String(),
      });
      await loadHistory();
    } catch (e) {
      debugPrint('Error saving prediction: $e');
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }
}

