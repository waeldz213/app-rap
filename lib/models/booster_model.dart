import 'package:cloud_firestore/cloud_firestore.dart';

class BoosterModel {
  final String id;
  final String userId;
  final List<String> cardsObtained;
  final int cost;
  final DateTime openedAt;

  const BoosterModel({
    required this.id,
    required this.userId,
    required this.cardsObtained,
    required this.cost,
    required this.openedAt,
  });

  factory BoosterModel.fromJson(Map<String, dynamic> json, String id) {
    return BoosterModel(
      id: id,
      userId: json['userId'] as String? ?? '',
      cardsObtained:
          List<String>.from(json['cardsObtained'] as List? ?? []),
      cost: json['cost'] as int? ?? 100,
      openedAt: json['openedAt'] != null
          ? (json['openedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'cardsObtained': cardsObtained,
        'cost': cost,
        'openedAt': Timestamp.fromDate(openedAt),
      };
}
