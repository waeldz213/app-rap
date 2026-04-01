import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType {
  purchase,
  reward,
  spend;

  static TransactionType fromString(String value) {
    switch (value) {
      case 'reward':
        return TransactionType.reward;
      case 'spend':
        return TransactionType.spend;
      default:
        return TransactionType.purchase;
    }
  }

  String toJson() => name;
}

enum TransactionCurrency {
  coins,
  xp;

  static TransactionCurrency fromString(String value) {
    switch (value) {
      case 'xp':
        return TransactionCurrency.xp;
      default:
        return TransactionCurrency.coins;
    }
  }

  String toJson() => name;
}

class TransactionModel {
  final String id;
  final String userId;
  final TransactionType type;
  final int amount;
  final TransactionCurrency currency;
  final String description;
  final DateTime createdAt;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.description,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: TransactionType.fromString(json['type'] as String? ?? 'purchase'),
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      currency: TransactionCurrency.fromString(
          json['currency'] as String? ?? 'coins'),
      description: json['description'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.toJson(),
      'amount': amount,
      'currency': currency.toJson(),
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
