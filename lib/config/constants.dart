class AppConstants {
  // Scoring
  static const int baseCorrectScore = 100;
  static const int baseDuelCorrectScore = 200;
  static const int speedBonus3s = 50;
  static const int speedBonus6s = 25;
  static const int speedBonus9s = 10;
  static const double streakMultiplier5 = 1.5;
  static const double streakMultiplier10 = 2.0;
  static const double cardEquippedBonus = 0.10;

  // Duel rewards
  static const int duelWinRankBonus = 30;
  static const int duelWinCoins = 50;
  static const int duelLoseRankPenalty = 15;
  static const int duelLoseCoins = 10;

  // Booster
  static const int boosterCardCount = 3;
  static const double communeDropRate = 0.60;
  static const double rareDropRate = 0.25;
  static const double epicDropRate = 0.12;
  static const double legendaryDropRate = 0.03;

  // Grind requirements
  static const int grindDuelWinsRequired = 20;
  static const int grindSoloCorrectRequired = 150;

  // Daily challenge
  static const double dailyChallengeBoosterChance = 0.30;
  static const int dailyChallengeCoins = 25;
  static const int dailyChallengeXp = 50;

  // Game
  static const int questionsPerDuel = 5;
  static const int streakBonus5Threshold = 5;
  static const int streakBonus10Threshold = 10;
  static const int questionTimeLimit = 15; // seconds

  // Animations
  static const Duration defaultAnimDuration = Duration(milliseconds: 300);
  static const Duration longAnimDuration = Duration(milliseconds: 600);
}
