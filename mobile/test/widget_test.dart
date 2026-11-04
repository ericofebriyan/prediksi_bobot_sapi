import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/constants/app_constants.dart';
import 'package:mobile/features/prediction/models/cattle_model.dart';
import 'package:mobile/features/prediction/models/prediction_result_model.dart';

void main() {
  group('Cattle Model & Constants Tests', () {
    test('AppConstants has required values', () {
      expect(AppConstants.appName, equals('SapiMadura AI'));
      expect(AppConstants.feedTypes, isNotEmpty);
      expect(AppConstants.genders, contains('Jantan'));
    });

    test('CattleModel serialization and deserialization', () {
      final cattle = CattleModel(
        id: 1,
        tagNumber: 'MDR-001',
        name: 'Sapi Madura Super',
        initialWeight: 220.0,
        entryAgeMonths: 18,
        gender: 'Jantan',
        feedType: 'Konsentrat + Hijauan (Rumput Gajah)',
        dailyFeedAmount: 20.0,
        feedFrequency: 3,
        healthCondition: 'Sehat & Aktif',
        vaccinationStatus: 'Sudah Vaksin Lengkap (PMK + Antraks)',
        targetWeight: 380.0,
      );

      final map = cattle.toMap();
      expect(map['tag_number'], equals('MDR-001'));
      expect(map['initial_weight'], equals(220.0));

      final fromMap = CattleModel.fromMap(map);
      expect(fromMap.tagNumber, equals('MDR-001'));
      expect(fromMap.initialWeight, equals(220.0));
      expect(fromMap.gender, equals('Jantan'));
    });

    test('PredictionResultModel properties', () {
      final result = PredictionResultModel(
        cattleTag: 'MDR-001',
        initialWeight: 220.0,
        targetWeight: 380.0,
        predictedADG: 0.85,
        daysToHarvest: 189,
        estimatedHarvestDate: DateTime.now().add(const Duration(days: 189)),
        totalWeightGain: 160.0,
        growthCurve: [
          GrowthPoint(day: 0, weight: 220.0),
          GrowthPoint(day: 189, weight: 380.0),
        ],
        recommendation: 'Kondisi sangat baik.',
      );

      expect(result.daysToHarvest, equals(189));
      expect(result.totalWeightGain, equals(160.0));
      expect(result.growthCurve.length, equals(2));
    });
  });
}
