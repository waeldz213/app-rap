import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;
  final int coins;
  final int xp;
  final int level;
  final int rankPoints;
  final String rankTier;
  final int streak;
  final DateTime? lastPlayedAt;
  final String? equippedCardId;
  final bool isPremium;
  final DateTime? premiumExpiresAt;
  final UserStats stats;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    required this.coins,
    required this.xp,
    required this.level,
    required this.rankPoints,
    required this.rankTier,
    required this.streak,
    this.lastPlayedAt,
    this.equippedCardId,
    required this.isPremium,
    this.premiumExpiresAt,
    required this.stats,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      coins: (json['coins'] as num?)?.toInt() ?? 0,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      rankPoints: (json['rankPoints'] as num?)?.toInt() ?? 0,
      rankTier: json['rankTier'] as String? ?? 'Bronze',
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      lastPlayedAt: json['lastPlayedAt'] != null
          ? (json['lastPlayedAt'] as Timestamp).toDate()
          : null,
      equippedCardId: json['equippedCardId'] as String?,
      isPremium: json['isPremium'] as bool? ?? false,
      premiumExpiresAt: json['premiumExpiresAt'] != null
          ? (json['premiumExpiresAt'] as Timestamp).toDate()
          : null,
      stats: UserStats.fromJson(
          (json['stats'] as Map<String, dynamic>?) ?? {}),
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
      'coins': coins,
      'xp': xp,
      'level': level,
      'rankPoints': rankPoints,
      'rankTier': rankTier,
      'streak': streak,
      'lastPlayedAt':
          lastPlayedAt != null ? Timestamp.fromDate(lastPlayedAt!) : null,
      'equippedCardId': equippedCardId,
      'isPremium': isPremium,
      'premiumExpiresAt': premiumExpiresAt != null
          ? Timestamp.fromDate(premiumExpiresAt!)
          : null,
      'stats': stats.toJson(),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? avatarUrl,
    int? coins,
    int? xp,
    int? level,
    int? rankPoints,
    String? rankTier,
    int? streak,
    DateTime? lastPlayedAt,
    String? equippedCardId,
    bool? isPremium,
    DateTime? premiumExpiresAt,
    UserStats? stats,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coins: coins ?? this.coins,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      rankPoints: rankPoints ?? this.rankPoints,
      rankTier: rankTier ?? this.rankTier,
      streak: streak ?? this.streak,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      equippedCardId: equippedCardId ?? this.equippedCardId,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiresAt: premiumExpiresAt ?? this.premiumExpiresAt,
      stats: stats ?? this.stats,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class UserStats {
  final int totalGamesPlayed;
  final int totalCorrectAnswers;
  final int totalDuelsPlayed;
  final int totalDuelWins;
  final int totalDuelLosses;
  final String? favoritePackId;

  const UserStats({
    required this.totalGamesPlayed,
    required this.totalCorrectAnswers,
    required this.totalDuelsPlayed,
    required this.totalDuelWins,
    required this.totalDuelLosses,
    this.favoritePackId,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalGamesPlayed: (json['totalGamesPlayed'] as num?)?.toInt() ?? 0,
      totalCorrectAnswers:
          (json['totalCorrectAnswers'] as num?)?.toInt() ?? 0,
      totalDuelsPlayed: (json['totalDuelsPlayed'] as num?)?.toInt() ?? 0,
      totalDuelWins: (json['totalDuelWins'] as num?)?.toInt() ?? 0,
      totalDuelLosses: (json['totalDuelLosses'] as num?)?.toInt() ?? 0,
      favoritePackId: json['favoritePackId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalGamesPlayed': totalGamesPlayed,
      'totalCorrectAnswers': totalCorrectAnswers,
      'totalDuelsPlayed': totalDuelsPlayed,
      'totalDuelWins': totalDuelWins,
      'totalDuelLosses': totalDuelLosses,
      'favoritePackId': favoritePackId,
    };
  }

  UserStats copyWith({
    int? totalGamesPlayed,
    int? totalCorrectAnswers,
    int? totalDuelsPlayed,
    int? totalDuelWins,
    int? totalDuelLosses,
    String? favoritePackId,
  }) {
    return UserStats(
      totalGamesPlayed: totalGamesPlayed ?? this.totalGamesPlayed,
      totalCorrectAnswers: totalCorrectAnswers ?? this.totalCorrectAnswers,
      totalDuelsPlayed: totalDuelsPlayed ?? this.totalDuelsPlayed,
      totalDuelWins: totalDuelWins ?? this.totalDuelWins,
      totalDuelLosses: totalDuelLosses ?? this.totalDuelLosses,
      favoritePackId: favoritePackId ?? this.favoritePackId,
    );
  }
}
