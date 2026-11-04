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
  final String modelUsed; // Misal: Ensemble (XGBoost + LightGBM + RF)
  final double confidenceScore;

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
    this.modelUsed = 'Ensemble Regressor (Offline Edge)',
    this.confidenceScore = 92.4,
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

