import 'package:cloud_firestore/cloud_firestore.dart';

class GrindRequirement {
  final int duelWinsRequired;
  final int soloCorrectRequired;

  const GrindRequirement({
    this.duelWinsRequired = 0,
    this.soloCorrectRequired = 0,
  });

  factory GrindRequirement.fromJson(Map<String, dynamic> json) {
    return GrindRequirement(
      duelWinsRequired: json['duelWinsRequired'] as int? ?? 0,
      soloCorrectRequired: json['soloCorrectRequired'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'duelWinsRequired': duelWinsRequired,
        'soloCorrectRequired': soloCorrectRequired,
      };
}

class PackModel {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String theme;
  final bool isFree;
  final String priceType; // 'free' | 'subscription' | 'grind'
  final bool isActive;
  final int sortOrder;
  final String coverImageUrl;
  final String gradientStart;
  final String gradientEnd;
  final String iconEmoji;
  final int questionCount;
  final GrindRequirement? grindRequirement;
  final DateTime? createdAt;

  const PackModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.theme,
    required this.isFree,
    required this.priceType,
    required this.isActive,
    required this.sortOrder,
    required this.coverImageUrl,
    required this.gradientStart,
    required this.gradientEnd,
    required this.iconEmoji,
    this.questionCount = 0,
    this.grindRequirement,
    this.createdAt,
  });

  factory PackModel.fromJson(Map<String, dynamic> json, String id) {
    return PackModel(
      id: id,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      theme: json['theme'] as String? ?? '',
      isFree: json['isFree'] as bool? ?? false,
      priceType: json['priceType'] as String? ?? 'subscription',
      isActive: json['isActive'] as bool? ?? true,
      sortOrder: json['sortOrder'] as int? ?? 99,
      coverImageUrl: json['coverImageUrl'] as String? ?? '',
      gradientStart: json['gradientStart'] as String? ?? '#7C3AED',
      gradientEnd: json['gradientEnd'] as String? ?? '#3B82F6',
      iconEmoji: json['iconEmoji'] as String? ?? '🎤',
      questionCount: json['questionCount'] as int? ?? 0,
      grindRequirement: json['grindRequirement'] != null
          ? GrindRequirement.fromJson(
              json['grindRequirement'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'description': description,
        'theme': theme,
        'isFree': isFree,
        'priceType': priceType,
        'isActive': isActive,
        'sortOrder': sortOrder,
        'coverImageUrl': coverImageUrl,
        'gradientStart': gradientStart,
        'gradientEnd': gradientEnd,
        'iconEmoji': iconEmoji,
        'questionCount': questionCount,
        'grindRequirement': grindRequirement?.toJson(),
        'createdAt':
            createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      };
}
