import 'package:cloud_firestore/cloud_firestore.dart';

class BoosterModel {
  final String id;
  final String userId;
  final List<String> cardIds;
  final DateTime openedAt;
  final String? packId;

  const BoosterModel({
    required this.id,
    required this.userId,
    required this.cardIds,
    required this.openedAt,
    this.packId,
  });

  factory BoosterModel.fromJson(Map<String, dynamic> json) {
    return BoosterModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      cardIds: List<String>.from(json['cardIds'] as List? ?? []),
      openedAt: json['openedAt'] != null
          ? (json['openedAt'] as Timestamp).toDate()
          : DateTime.now(),
      packId: json['packId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'cardIds': cardIds,
      'openedAt': Timestamp.fromDate(openedAt),
      'packId': packId,
    };
  }
}
