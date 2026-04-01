import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/constants.dart';
import 'firestore_service.dart';

class ScoringService {
  final FirestoreService _firestoreService;

  ScoringService(this._firestoreService);

  /// Calculate speed bonus based on seconds used to answer
  int calculateSpeedBonus(int secondsUsed) {
    if (secondsUsed <= 3) return AppConstants.speedBonus3s;
    if (secondsUsed <= 6) return AppConstants.speedBonus6s;
    if (secondsUsed <= 9) return AppConstants.speedBonus9s;
    return 0;
  }

  /// Calculate streak multiplier
  double calculateStreakMultiplier(int streak) {
    if (streak >= AppConstants.streakBonus10Threshold) {
      return AppConstants.streakMultiplier10;
    }
    if (streak >= AppConstants.streakBonus5Threshold) {
      return AppConstants.streakMultiplier5;
    }
    return 1.0;
  }

  /// Calculate full quiz score for a single correct answer
  int calculateQuizScore({
    required int correctAnswers,
    required int totalTime,
    required int streak,
    required bool hasEquippedCard,
  }) {
    int baseScore = correctAnswers * AppConstants.baseCorrectScore;
    int speedBonus = calculateSpeedBonus(totalTime);
    double streakMultiplier = calculateStreakMultiplier(streak);

    double score = (baseScore + speedBonus) * streakMultiplier;

    if (hasEquippedCard) {
      score *= (1.0 + AppConstants.cardEquippedBonus);
    }

    return score.round();
  }

  /// Calculate duel score for a single correct answer
  int calculateDuelScore({
    required int correctAnswers,
    required int totalTime,
    required int streak,
  }) {
    int baseScore = correctAnswers * AppConstants.baseDuelCorrectScore;
    int speedBonus = calculateSpeedBonus(totalTime);
    double streakMultiplier = calculateStreakMultiplier(streak);

    return ((baseScore + speedBonus) * streakMultiplier).round();
  }

  /// Award coins and XP to user
  Future<void> awardCoinsAndXP(
      String userId, int coins, int xp) async {
    await _firestoreService.users.doc(userId).update({
      'coins': FieldValue.increment(coins),
      'xp': FieldValue.increment(xp),
    });

    // Log transaction
    await _firestoreService.transactions.add({
      'userId': userId,
      'type': 'reward',
      'amount': coins,
      'currency': 'coins',
      'description': 'Quiz reward',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Calculate level from XP
  static int xpToLevel(int xp) {
    // Each level requires level * 500 XP
    int level = 1;
    int xpRequired = 0;
    while (xpRequired + level * 500 <= xp) {
      xpRequired += level * 500;
      level++;
    }
    return level;
  }

  /// XP needed for next level
  static int xpForNextLevel(int level) => level * 500;

  /// XP progress within current level
  static int xpProgressInLevel(int xp, int level) {
    int totalXpForCurrentLevel = 0;
    for (int i = 1; i < level; i++) {
      totalXpForCurrentLevel += i * 500;
    }
    return xp - totalXpForCurrentLevel;
  }
}
