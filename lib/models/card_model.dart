enum CardRarity {
  commune,
  rare,
  epic,
  legendary;

  static CardRarity fromString(String value) {
    switch (value) {
      case 'rare':
        return CardRarity.rare;
      case 'epic':
        return CardRarity.epic;
      case 'legendary':
        return CardRarity.legendary;
      default:
        return CardRarity.commune;
    }
  }

  String toJson() => name;

  String get displayName {
    switch (this) {
      case CardRarity.commune:
        return 'Commune';
      case CardRarity.rare:
        return 'Rare';
      case CardRarity.epic:
        return 'Épique';
      case CardRarity.legendary:
        return 'Légendaire';
    }
  }
}

class CardModel {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final CardRarity rarity;
  final String artist;
  final String? era;
  final String? bonusType;
  final double? bonusValue;
  final String? packId;

  const CardModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.rarity,
    required this.artist,
    this.era,
    this.bonusType,
    this.bonusValue,
    this.packId,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      rarity: CardRarity.fromString(json['rarity'] as String? ?? 'commune'),
      artist: json['artist'] as String? ?? '',
      era: json['era'] as String?,
      bonusType: json['bonusType'] as String?,
      bonusValue: (json['bonusValue'] as num?)?.toDouble(),
      packId: json['packId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'rarity': rarity.toJson(),
      'artist': artist,
      'era': era,
      'bonusType': bonusType,
      'bonusValue': bonusValue,
      'packId': packId,
    };
  }
}
