import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType {
  subscription,
  booster,
  reward,
  duelReward,
  dailyReward,
  refund,
}

extension TransactionTypeExtension on TransactionType {
  String get value {
    switch (this) {
      case TransactionType.subscription:
        return 'subscription';
      case TransactionType.booster:
        return 'booster';
      case TransactionType.reward:
        return 'reward';
      case TransactionType.duelReward:
        return 'duelReward';
      case TransactionType.dailyReward:
        return 'dailyReward';
      case TransactionType.refund:
        return 'refund';
    }
  }
}

TransactionType transactionTypeFromString(String value) {
  switch (value) {
    case 'subscription':
      return TransactionType.subscription;
    case 'booster':
      return TransactionType.booster;
    case 'reward':
      return TransactionType.reward;
    case 'duelReward':
      return TransactionType.duelReward;
    case 'dailyReward':
      return TransactionType.dailyReward;
    case 'refund':
      return TransactionType.refund;
    default:
      return TransactionType.reward;
  }
}

class TransactionModel {
  final String id;
  final String userId;
  final TransactionType type;
  final int coinsAmount; // positive = credit, negative = debit
  final int xpAmount;
  final String? productId;
  final String? platform;
  final String? purchaseToken;
  final String description;
  final DateTime createdAt;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    this.coinsAmount = 0,
    this.xpAmount = 0,
    this.productId,
    this.platform,
    this.purchaseToken,
    required this.description,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json, String id) {
    return TransactionModel(
      id: id,
      userId: json['userId'] as String? ?? '',
      type: transactionTypeFromString(json['type'] as String? ?? 'reward'),
      coinsAmount: json['coinsAmount'] as int? ?? 0,
      xpAmount: json['xpAmount'] as int? ?? 0,
      productId: json['productId'] as String?,
      platform: json['platform'] as String?,
      purchaseToken: json['purchaseToken'] as String?,
      description: json['description'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'type': type.value,
        'coinsAmount': coinsAmount,
        'xpAmount': xpAmount,
        'productId': productId,
        'platform': platform,
        'purchaseToken': purchaseToken,
        'description': description,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
