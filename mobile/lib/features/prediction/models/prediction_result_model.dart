class GrowthPoint {
  final double day;
  final double weight;

  GrowthPoint({required this.day, required this.weight});
}

class PredictionResultModel {
  final String cattleTag;
  final double initialWeight;
  final double targetWeight;
  final double predictedADG; // Average Daily Gain (kg/hari)
  final int daysToHarvest; // Jumlah hari menuju panen
  final DateTime estimatedHarvestDate;
  final double totalWeightGain;
  final List<GrowthPoint> growthCurve;
  final String recommendation;
  final String modelUsed; // Misal: Weighted Ensemble (XGBoost + LightGBM + RF)
  final double confidenceScore;
  final bool isFromBackendApi;

  // Sub-estimasi masing-masing model dalam Ensemble (50% XGBoost, 35% LightGBM, 15% RF)
  final int? xgboostDays;
  final double? xgboostAdg;
  final int? lightgbmDays;
  final double? lightgbmAdg;
  final int? rfDays;
  final double? rfAdg;

  PredictionResultModel({
    required this.cattleTag,
    required this.initialWeight,
    required this.targetWeight,
    required this.predictedADG,
    required this.daysToHarvest,
    required this.estimatedHarvestDate,
    required this.totalWeightGain,
    required this.growthCurve,
    required this.recommendation,
    this.modelUsed = 'Weighted Ensemble (XGBoost + LightGBM + RF)',
    this.confidenceScore = 92.0,
    this.isFromBackendApi = false,
    this.xgboostDays,
    this.xgboostAdg,
    this.lightgbmDays,
    this.lightgbmAdg,
    this.rfDays,
    this.rfAdg,
  });

  Map<String, dynamic> toMap() {
    return {
      'cattle_tag': cattleTag,
      'initial_weight': initialWeight,
      'target_weight': targetWeight,
      'predicted_adg': predictedADG,
      'estimated_days': daysToHarvest,
      'estimated_harvest_date': estimatedHarvestDate.toIso8601String(),
      'feed_type': '',
      'created_at': DateTime.now().toIso8601String(),
    };
  }
}
