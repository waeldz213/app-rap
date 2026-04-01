import 'package:cloud_firestore/cloud_firestore.dart';

enum DuelStatus {
  waiting,
  active,
  completed,
  cancelled;

  static DuelStatus fromString(String value) {
    switch (value) {
      case 'active':
        return DuelStatus.active;
      case 'completed':
        return DuelStatus.completed;
      case 'cancelled':
        return DuelStatus.cancelled;
      default:
        return DuelStatus.waiting;
    }
  }

  String toJson() => name;
}

class DuelModel {
  final String id;
  final String initiatorUserId;
  final String? opponentUserId;
  final DuelStatus status;
  final List<String> questionIds;
  final List<DuelAnswer> initiatorAnswers;
  final List<DuelAnswer> opponentAnswers;
  final int initiatorScore;
  final int opponentScore;
  final String? winnerId;
  final DateTime createdAt;
  final DateTime? completedAt;

  const DuelModel({
    required this.id,
    required this.initiatorUserId,
    this.opponentUserId,
    required this.status,
    required this.questionIds,
    required this.initiatorAnswers,
    required this.opponentAnswers,
    required this.initiatorScore,
    required this.opponentScore,
    this.winnerId,
    required this.createdAt,
    this.completedAt,
  });

  factory DuelModel.fromJson(Map<String, dynamic> json) {
    return DuelModel(
      id: json['id'] as String,
      initiatorUserId: json['initiatorUserId'] as String,
      opponentUserId: json['opponentUserId'] as String?,
      status: DuelStatus.fromString(json['status'] as String? ?? 'waiting'),
      questionIds: List<String>.from(json['questionIds'] as List? ?? []),
      initiatorAnswers: (json['initiatorAnswers'] as List? ?? [])
          .map((e) => DuelAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
      opponentAnswers: (json['opponentAnswers'] as List? ?? [])
          .map((e) => DuelAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
      initiatorScore: (json['initiatorScore'] as num?)?.toInt() ?? 0,
      opponentScore: (json['opponentScore'] as num?)?.toInt() ?? 0,
      winnerId: json['winnerId'] as String?,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      completedAt: json['completedAt'] != null
          ? (json['completedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'initiatorUserId': initiatorUserId,
      'opponentUserId': opponentUserId,
      'status': status.toJson(),
      'questionIds': questionIds,
      'initiatorAnswers': initiatorAnswers.map((a) => a.toJson()).toList(),
      'opponentAnswers': opponentAnswers.map((a) => a.toJson()).toList(),
      'initiatorScore': initiatorScore,
      'opponentScore': opponentScore,
      'winnerId': winnerId,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }

  DuelModel copyWith({
    String? id,
    String? initiatorUserId,
    String? opponentUserId,
    DuelStatus? status,
    List<String>? questionIds,
    List<DuelAnswer>? initiatorAnswers,
    List<DuelAnswer>? opponentAnswers,
    int? initiatorScore,
    int? opponentScore,
    String? winnerId,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return DuelModel(
      id: id ?? this.id,
      initiatorUserId: initiatorUserId ?? this.initiatorUserId,
      opponentUserId: opponentUserId ?? this.opponentUserId,
      status: status ?? this.status,
      questionIds: questionIds ?? this.questionIds,
      initiatorAnswers: initiatorAnswers ?? this.initiatorAnswers,
      opponentAnswers: opponentAnswers ?? this.opponentAnswers,
      initiatorScore: initiatorScore ?? this.initiatorScore,
      opponentScore: opponentScore ?? this.opponentScore,
      winnerId: winnerId ?? this.winnerId,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

class DuelAnswer {
  final String questionId;
  final String selectedAnswer;
  final bool isCorrect;
  final int timeSpent;
  final int scoreEarned;

  const DuelAnswer({
    required this.questionId,
    required this.selectedAnswer,
    required this.isCorrect,
    required this.timeSpent,
    required this.scoreEarned,
  });

  factory DuelAnswer.fromJson(Map<String, dynamic> json) {
    return DuelAnswer(
      questionId: json['questionId'] as String,
      selectedAnswer: json['selectedAnswer'] as String,
      isCorrect: json['isCorrect'] as bool? ?? false,
      timeSpent: (json['timeSpent'] as num?)?.toInt() ?? 0,
      scoreEarned: (json['scoreEarned'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'selectedAnswer': selectedAnswer,
      'isCorrect': isCorrect,
      'timeSpent': timeSpent,
      'scoreEarned': scoreEarned,
    };
  }
}
