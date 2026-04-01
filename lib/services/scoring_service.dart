import '../config/constants.dart';

class ScoringResult {
  final int basePoints;
  final int speedBonus;
  final int streakBonus;
  final int cardBonus;
  final int total;

  const ScoringResult({
    required this.basePoints,
    required this.speedBonus,
    required this.streakBonus,
    required this.cardBonus,
    required this.total,
  });
}

class ScoringService {
  /// Calculate score for a single correct answer.
  /// [timeSpentMs] time taken to answer in milliseconds
  /// [streak] current consecutive correct answers
  /// [cardBonusMultiplier] bonus from equipped cards (e.g. 0.05 = +5%)
  ScoringResult calculateScore({
    required bool isCorrect,
    required int timeSpentMs,
    required int streak,
    double cardBonusMultiplier = 0.0,
  }) {
    if (!isCorrect) {
      return const ScoringResult(
        basePoints: 0,
        speedBonus: 0,
        streakBonus: 0,
        cardBonus: 0,
        total: 0,
      );
    }

    final basePoints = AppConstants.baseCorrectPoints;

    // Speed bonus: up to 50 points if answered in < 5s
    final maxSpeedMs = AppConstants.questionTimerSeconds * 1000;
    final speedRatio = 1.0 - (timeSpentMs / maxSpeedMs).clamp(0.0, 1.0);
    final speedBonus = (AppConstants.speedBonusMax * speedRatio).round();

    // Streak bonus
    int streakBonus = 0;
    if (streak >= AppConstants.streakThreshold3) {
      streakBonus = AppConstants.streakBonus10;
    } else if (streak >= AppConstants.streakThreshold2) {
      streakBonus = AppConstants.streakBonus5;
    } else if (streak >= AppConstants.streakThreshold1) {
      streakBonus = AppConstants.streakBonus3;
    }

    final subtotal = basePoints + speedBonus + streakBonus;

    // Card bonus (percentage of subtotal)
    final cardBonus = (subtotal * cardBonusMultiplier).round();

    final total = subtotal + cardBonus;

    return ScoringResult(
      basePoints: basePoints,
      speedBonus: speedBonus,
      streakBonus: streakBonus,
      cardBonus: cardBonus,
      total: total,
    );
  }

  /// Calculate XP gained from a quiz session
  int calculateXpGained({
    required int correctAnswers,
    required bool isDaily,
    bool isDuelWin = false,
  }) {
    int xp = correctAnswers * AppConstants.xpPerCorrect;
    if (isDaily) xp += AppConstants.xpDailyChallenge;
    if (isDuelWin) xp += AppConstants.xpDuelWin;
    return xp;
  }

  /// Calculate coins gained from a quiz session
  int calculateCoinsGained({
    required int correctAnswers,
    required bool isDaily,
    bool isDuelWin = false,
    bool isDuelLoss = false,
  }) {
    int coins = correctAnswers * AppConstants.coinsPerCorrect;
    if (isDaily) coins += AppConstants.coinsDaily;
    if (isDuelWin) coins += AppConstants.coinsDuelWin;
    if (isDuelLoss) coins += AppConstants.coinsDuelLoss;
    return coins;
  }

  /// Calculate new level from XP
  int calculateLevel(int totalXp) {
    return (totalXp / AppConstants.xpPerLevel).floor() + 1;
  }

  /// Calculate XP progress within current level
  double calculateXpProgress(int totalXp) {
    final xpInLevel = totalXp % AppConstants.xpPerLevel;
    return xpInLevel / AppConstants.xpPerLevel;
  }

  /// Calculate total equipped card bonus multiplier
  double calculateCardBonusMultiplier(List<double> cardBonusValues) {
    if (cardBonusValues.isEmpty) return 0.0;
    // Sum all card bonuses, cap at 50%
    final total = cardBonusValues.fold(0.0, (sum, v) => sum + v);
    return total.clamp(0.0, 0.5);
  }
}
