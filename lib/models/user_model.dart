import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final bool isPremium;
  final DateTime? premiumUntil;
  final int xp;
  final int level;
  final int coins;
  final UserStats stats;
  final List<String> equippedCardIds;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    this.isPremium = false,
    this.premiumUntil,
    this.xp = 0,
    this.level = 1,
    this.coins = 0,
    required this.stats,
    this.equippedCardIds = const [],
    required this.createdAt,
    this.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String? ?? 'Rappeur',
      avatarUrl: json['avatarUrl'] as String?,
      isPremium: json['isPremium'] as bool? ?? false,
      premiumUntil: json['premiumUntil'] != null
          ? (json['premiumUntil'] as Timestamp).toDate()
          : null,
      xp: json['xp'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      coins: json['coins'] as int? ?? 0,
      stats: json['stats'] != null
          ? UserStats.fromJson(json['stats'] as Map<String, dynamic>)
          : const UserStats(),
      equippedCardIds: List<String>.from(json['equippedCardIds'] as List? ?? []),
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      lastLoginAt: json['lastLoginAt'] != null
          ? (json['lastLoginAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'isPremium': isPremium,
      'premiumUntil':
          premiumUntil != null ? Timestamp.fromDate(premiumUntil!) : null,
      'xp': xp,
      'level': level,
      'coins': coins,
      'stats': stats.toJson(),
      'equippedCardIds': equippedCardIds,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt':
          lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
    };
  }

  UserModel copyWith({
    String? displayName,
    String? avatarUrl,
    bool? isPremium,
    DateTime? premiumUntil,
    int? xp,
    int? level,
    int? coins,
    UserStats? stats,
    List<String>? equippedCardIds,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isPremium: isPremium ?? this.isPremium,
      premiumUntil: premiumUntil ?? this.premiumUntil,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      coins: coins ?? this.coins,
      stats: stats ?? this.stats,
      equippedCardIds: equippedCardIds ?? this.equippedCardIds,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}

class UserStats {
  final int totalQuizzes;
  final int totalCorrect;
  final int totalQuestions;
  final int currentStreak;
  final int maxStreak;
  final int totalDuels;
  final int duelWins;
  final int totalCards;
  final int boostersOpened;
  final int dailyChallengesCompleted;

  const UserStats({
    this.totalQuizzes = 0,
    this.totalCorrect = 0,
    this.totalQuestions = 0,
    this.currentStreak = 0,
    this.maxStreak = 0,
    this.totalDuels = 0,
    this.duelWins = 0,
    this.totalCards = 0,
    this.boostersOpened = 0,
    this.dailyChallengesCompleted = 0,
  });

  double get accuracy =>
      totalQuestions > 0 ? totalCorrect / totalQuestions : 0.0;

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalQuizzes: json['totalQuizzes'] as int? ?? 0,
      totalCorrect: json['totalCorrect'] as int? ?? 0,
      totalQuestions: json['totalQuestions'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      maxStreak: json['maxStreak'] as int? ?? 0,
      totalDuels: json['totalDuels'] as int? ?? 0,
      duelWins: json['duelWins'] as int? ?? 0,
      totalCards: json['totalCards'] as int? ?? 0,
      boostersOpened: json['boostersOpened'] as int? ?? 0,
      dailyChallengesCompleted:
          json['dailyChallengesCompleted'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'totalQuizzes': totalQuizzes,
        'totalCorrect': totalCorrect,
        'totalQuestions': totalQuestions,
        'currentStreak': currentStreak,
        'maxStreak': maxStreak,
        'totalDuels': totalDuels,
        'duelWins': duelWins,
        'totalCards': totalCards,
        'boostersOpened': boostersOpened,
        'dailyChallengesCompleted': dailyChallengesCompleted,
      };

  UserStats copyWith({
    int? totalQuizzes,
    int? totalCorrect,
    int? totalQuestions,
    int? currentStreak,
    int? maxStreak,
    int? totalDuels,
    int? duelWins,
    int? totalCards,
    int? boostersOpened,
    int? dailyChallengesCompleted,
  }) {
    return UserStats(
      totalQuizzes: totalQuizzes ?? this.totalQuizzes,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      currentStreak: currentStreak ?? this.currentStreak,
      maxStreak: maxStreak ?? this.maxStreak,
      totalDuels: totalDuels ?? this.totalDuels,
      duelWins: duelWins ?? this.duelWins,
      totalCards: totalCards ?? this.totalCards,
      boostersOpened: boostersOpened ?? this.boostersOpened,
      dailyChallengesCompleted:
          dailyChallengesCompleted ?? this.dailyChallengesCompleted,
    );
  }
}
