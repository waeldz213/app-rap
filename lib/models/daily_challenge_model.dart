import 'package:cloud_firestore/cloud_firestore.dart';

class DailyChallengeModel {
  final String id;
  final String date;
  final List<String> questionIds;
  final List<String> completedByUserIds;
  final Map<String, dynamic> rewards;

  const DailyChallengeModel({
    required this.id,
    required this.date,
    required this.questionIds,
    required this.completedByUserIds,
    required this.rewards,
  });

  factory DailyChallengeModel.fromJson(Map<String, dynamic> json) {
    return DailyChallengeModel(
      id: json['id'] as String,
      date: json['date'] as String,
      questionIds: List<String>.from(json['questionIds'] as List? ?? []),
      completedByUserIds:
          List<String>.from(json['completedByUserIds'] as List? ?? []),
      rewards: Map<String, dynamic>.from(
          json['rewards'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'questionIds': questionIds,
      'completedByUserIds': completedByUserIds,
      'rewards': rewards,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  int get coins => (rewards['coins'] as num?)?.toInt() ?? 0;
  int get xp => (rewards['xp'] as num?)?.toInt() ?? 0;
  double get boosterChance =>
      (rewards['boosterChance'] as num?)?.toDouble() ?? 0.0;
}
