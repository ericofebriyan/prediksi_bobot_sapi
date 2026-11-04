class CattleModel {
  final int? id;
  final String tagNumber;
  final String name;
  final double initialWeight; // kg
  final int entryAgeMonths; // bulan
  final String gender; // Jantan / Betina
  final String feedType;
  final double dailyFeedAmount; // kg/hari
  final int feedFrequency; // kali/hari
  final String healthCondition;
  final String vaccinationStatus;
  final double targetWeight; // kg
  final DateTime createdAt;

  CattleModel({
    this.id,
    required this.tagNumber,
    required this.name,
    required this.initialWeight,
    required this.entryAgeMonths,
    required this.gender,
    required this.feedType,
    required this.dailyFeedAmount,
    required this.feedFrequency,
    required this.healthCondition,
    required this.vaccinationStatus,
    required this.targetWeight,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tag_number': tagNumber,
      'name': name,
      'initial_weight': initialWeight,
      'entry_age_months': entryAgeMonths,
      'gender': gender,
      'feed_type': feedType,
      'daily_feed_amount': dailyFeedAmount,
      'feed_frequency': feedFrequency,
      'health_condition': healthCondition,
      'vaccination_status': vaccinationStatus,
      'target_weight': targetWeight,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory CattleModel.fromMap(Map<String, dynamic> map) {
    return CattleModel(
      id: map['id'] as int?,
      tagNumber: map['tag_number'] as String,
      name: map['name'] as String? ?? 'Sapi #${map['tag_number']}',
      initialWeight: (map['initial_weight'] as num).toDouble(),
      entryAgeMonths: map['entry_age_months'] as int,
      gender: map['gender'] as String,
      feedType: map['feed_type'] as String,
      dailyFeedAmount: (map['daily_feed_amount'] as num).toDouble(),
      feedFrequency: map['feed_frequency'] as int,
      healthCondition: map['health_condition'] as String,
      vaccinationStatus: map['vaccination_status'] as String,
      targetWeight: (map['target_weight'] as num).toDouble(),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}

