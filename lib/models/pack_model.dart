import 'package:cloud_firestore/cloud_firestore.dart';

class PackModel {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final bool isPremium;
  final int? price;
  final int questionCount;
  final String category;
  final String? artist;
  final String? era;
  final int difficulty;
  final int totalPlays;
  final GrindRequirement? grindRequirement;
  final bool isActive;
  final DateTime createdAt;

  const PackModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.isPremium,
    this.price,
    required this.questionCount,
    required this.category,
    this.artist,
    this.era,
    required this.difficulty,
    required this.totalPlays,
    this.grindRequirement,
    required this.isActive,
    required this.createdAt,
  });

  factory PackModel.fromJson(Map<String, dynamic> json) {
    return PackModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      isPremium: json['isPremium'] as bool? ?? false,
      price: (json['price'] as num?)?.toInt(),
      questionCount: (json['questionCount'] as num?)?.toInt() ?? 0,
      category: json['category'] as String? ?? 'général',
      artist: json['artist'] as String?,
      era: json['era'] as String?,
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
      totalPlays: (json['totalPlays'] as num?)?.toInt() ?? 0,
      grindRequirement: json['grindRequirement'] != null
          ? GrindRequirement.fromJson(
              json['grindRequirement'] as Map<String, dynamic>)
          : null,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'isPremium': isPremium,
      'price': price,
      'questionCount': questionCount,
      'category': category,
      'artist': artist,
      'era': era,
      'difficulty': difficulty,
      'totalPlays': totalPlays,
      'grindRequirement': grindRequirement?.toJson(),
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class GrindRequirement {
  final int duelWinsRequired;
  final int soloCorrectRequired;

  const GrindRequirement({
    required this.duelWinsRequired,
    required this.soloCorrectRequired,
  });

  factory GrindRequirement.fromJson(Map<String, dynamic> json) {
    return GrindRequirement(
      duelWinsRequired: (json['duelWinsRequired'] as num?)?.toInt() ?? 0,
      soloCorrectRequired:
          (json['soloCorrectRequired'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duelWinsRequired': duelWinsRequired,
      'soloCorrectRequired': soloCorrectRequired,
    };
  }
}
