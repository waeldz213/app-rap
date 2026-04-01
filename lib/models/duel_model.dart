import 'package:cloud_firestore/cloud_firestore.dart';

enum DuelStatus {
  waiting,
  active,
  completed,
  expired,
}

extension DuelStatusExtension on DuelStatus {
  String get value {
    switch (this) {
      case DuelStatus.waiting:
        return 'waiting';
      case DuelStatus.active:
        return 'active';
      case DuelStatus.completed:
        return 'completed';
      case DuelStatus.expired:
        return 'expired';
    }
  }
}

DuelStatus duelStatusFromString(String value) {
  switch (value) {
    case 'active':
      return DuelStatus.active;
    case 'completed':
      return DuelStatus.completed;
    case 'expired':
      return DuelStatus.expired;
    default:
      return DuelStatus.waiting;
  }
}

class DuelAnswer {
  final String questionId;
  final String answer;
  final bool isCorrect;
  final int points;
  final int timeSpentMs;

  const DuelAnswer({
    required this.questionId,
    required this.answer,
    required this.isCorrect,
    required this.points,
    required this.timeSpentMs,
  });

  factory DuelAnswer.fromJson(Map<String, dynamic> json) {
    return DuelAnswer(
      questionId: json['questionId'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      isCorrect: json['isCorrect'] as bool? ?? false,
      points: json['points'] as int? ?? 0,
      timeSpentMs: json['timeSpentMs'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        'answer': answer,
        'isCorrect': isCorrect,
        'points': points,
        'timeSpentMs': timeSpentMs,
      };
}

class DuelModel {
  final String id;
  final String packId;
  final String packTitle;
  final String inviteCode;
  final String initiatorUserId;
  final String initiatorDisplayName;
  final String? opponentUserId;
  final String? opponentDisplayName;
  final DuelStatus status;
  final List<String> questionIds;
  final List<DuelAnswer> initiatorAnswers;
  final List<DuelAnswer> opponentAnswers;
  final int initiatorScore;
  final int opponentScore;
  final String? winnerId;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  const DuelModel({
    required this.id,
    required this.packId,
    required this.packTitle,
    required this.inviteCode,
    required this.initiatorUserId,
    required this.initiatorDisplayName,
    this.opponentUserId,
    this.opponentDisplayName,
    required this.status,
    required this.questionIds,
    this.initiatorAnswers = const [],
    this.opponentAnswers = const [],
    this.initiatorScore = 0,
    this.opponentScore = 0,
    this.winnerId,
    required this.createdAt,
    this.resolvedAt,
  });

  factory DuelModel.fromJson(Map<String, dynamic> json, String id) {
    return DuelModel(
      id: id,
      packId: json['packId'] as String? ?? '',
      packTitle: json['packTitle'] as String? ?? '',
      inviteCode: json['inviteCode'] as String? ?? '',
      initiatorUserId: json['initiatorUserId'] as String? ?? '',
      initiatorDisplayName:
          json['initiatorDisplayName'] as String? ?? 'Joueur',
      opponentUserId: json['opponentUserId'] as String?,
      opponentDisplayName: json['opponentDisplayName'] as String?,
      status: duelStatusFromString(json['status'] as String? ?? 'waiting'),
      questionIds:
          List<String>.from(json['questionIds'] as List? ?? []),
      initiatorAnswers: (json['initiatorAnswers'] as List? ?? [])
          .map((e) => DuelAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
      opponentAnswers: (json['opponentAnswers'] as List? ?? [])
          .map((e) => DuelAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
      initiatorScore: json['initiatorScore'] as int? ?? 0,
      opponentScore: json['opponentScore'] as int? ?? 0,
      winnerId: json['winnerId'] as String?,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      resolvedAt: json['resolvedAt'] != null
          ? (json['resolvedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'packId': packId,
        'packTitle': packTitle,
        'inviteCode': inviteCode,
        'initiatorUserId': initiatorUserId,
        'initiatorDisplayName': initiatorDisplayName,
        'opponentUserId': opponentUserId,
        'opponentDisplayName': opponentDisplayName,
        'status': status.value,
        'questionIds': questionIds,
        'initiatorAnswers':
            initiatorAnswers.map((a) => a.toJson()).toList(),
        'opponentAnswers':
            opponentAnswers.map((a) => a.toJson()).toList(),
        'initiatorScore': initiatorScore,
        'opponentScore': opponentScore,
        'winnerId': winnerId,
        'createdAt': Timestamp.fromDate(createdAt),
        'resolvedAt':
            resolvedAt != null ? Timestamp.fromDate(resolvedAt!) : null,
      };
}
