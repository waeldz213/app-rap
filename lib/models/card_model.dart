import 'package:cloud_firestore/cloud_firestore.dart';

enum CardRarity {
  commune,
  rare,
  epique,
  legendaire,
}

extension CardRarityExtension on CardRarity {
  String get label {
    switch (this) {
      case CardRarity.commune:
        return 'Commune';
      case CardRarity.rare:
        return 'Rare';
      case CardRarity.epique:
        return 'Épique';
      case CardRarity.legendaire:
        return 'Légendaire';
    }
  }

  String get value {
    switch (this) {
      case CardRarity.commune:
        return 'commune';
      case CardRarity.rare:
        return 'rare';
      case CardRarity.epique:
        return 'epique';
      case CardRarity.legendaire:
        return 'legendaire';
    }
  }
}

CardRarity rarityFromString(String value) {
  switch (value) {
    case 'rare':
      return CardRarity.rare;
    case 'epique':
      return CardRarity.epique;
    case 'legendaire':
      return CardRarity.legendaire;
    default:
      return CardRarity.commune;
  }
}

class CardModel {
  final String id;
  final String artistName;
  final CardRarity rarity;
  final String title;
  final String flavorText;
  final String? imageUrl;
  final String bonusType; // 'score_boost' | 'time_bonus' | 'coin_boost'
  final double bonusValue;
  final bool isActive;
  final DateTime? createdAt;

  // User-specific fields (when fetched from user collection)
  final int count;
  final DateTime? obtainedAt;

  const CardModel({
    required this.id,
    required this.artistName,
    required this.rarity,
    required this.title,
    required this.flavorText,
    this.imageUrl,
    required this.bonusType,
    required this.bonusValue,
    this.isActive = true,
    this.createdAt,
    this.count = 1,
    this.obtainedAt,
  });

  factory CardModel.fromJson(Map<String, dynamic> json, String id) {
    return CardModel(
      id: id,
      artistName: json['artistName'] as String? ?? '',
      rarity: rarityFromString(json['rarity'] as String? ?? 'commune'),
      title: json['title'] as String? ?? '',
      flavorText: json['flavorText'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      bonusType: json['bonusType'] as String? ?? 'score_boost',
      bonusValue: (json['bonusValue'] as num?)?.toDouble() ?? 0.05,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      count: json['count'] as int? ?? 1,
      obtainedAt: json['obtainedAt'] != null
          ? (json['obtainedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'artistName': artistName,
        'rarity': rarity.value,
        'title': title,
        'flavorText': flavorText,
        'imageUrl': imageUrl,
        'bonusType': bonusType,
        'bonusValue': bonusValue,
        'isActive': isActive,
        'createdAt':
            createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      };
}
