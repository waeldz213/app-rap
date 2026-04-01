import 'package:cloud_firestore/cloud_firestore.dart';

class DailyChallengeModel {
  final String id; // YYYY-MM-DD
  final String date;
  final String packId;
  final String packTitle;
  final List<String> questionIds;
  final int bonusCoins;
  final int bonusXp;
  final DateTime createdAt;
  final bool? isCompleted; // user-specific

  const DailyChallengeModel({
    required this.id,
    required this.date,
    required this.packId,
    required this.packTitle,
    required this.questionIds,
    required this.bonusCoins,
    required this.bonusXp,
    required this.createdAt,
    this.isCompleted,
  });

  factory DailyChallengeModel.fromJson(Map<String, dynamic> json, String id) {
    return DailyChallengeModel(
      id: id,
      date: json['date'] as String? ?? id,
      packId: json['packId'] as String? ?? '',
      packTitle: json['packTitle'] as String? ?? '',
      questionIds: List<String>.from(json['questionIds'] as List? ?? []),
      bonusCoins: json['bonusCoins'] as int? ?? 30,
      bonusXp: json['bonusXp'] as int? ?? 150,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      isCompleted: json['isCompleted'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'packId': packId,
        'packTitle': packTitle,
        'questionIds': questionIds,
        'bonusCoins': bonusCoins,
        'bonusXp': bonusXp,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  DailyChallengeModel copyWith({bool? isCompleted}) {
    return DailyChallengeModel(
      id: id,
      date: date,
      packId: packId,
      packTitle: packTitle,
      questionIds: questionIds,
      bonusCoins: bonusCoins,
      bonusXp: bonusXp,
      createdAt: createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
