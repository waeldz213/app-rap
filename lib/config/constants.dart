class AppConstants {
  // ─── App Info ─────────────────────────────────────────────────────────────
  static const String appName = 'App Rap';
  static const String appVersion = '1.0.0';

  // ─── Scoring ─────────────────────────────────────────────────────────────
  static const int baseCorrectPoints = 100;
  static const int speedBonusMax = 50;
  static const int streakBonus3 = 25;
  static const int streakBonus5 = 50;
  static const int streakBonus10 = 100;
  static const double cardBonusMultiplierPerLevel = 0.05;

  // ─── XP ──────────────────────────────────────────────────────────────────
  static const int xpPerCorrect = 20;
  static const int xpDuelWin = 100;
  static const int xpDuelLoss = 30;
  static const int xpDailyChallenge = 150;
  static const int xpPerLevel = 1000;

  // ─── Coins ────────────────────────────────────────────────────────────────
  static const int coinsPerCorrect = 5;
  static const int coinsDuelWin = 50;
  static const int coinsDuelLoss = 10;
  static const int coinsDaily = 30;
  static const int boosterCost = 100;

  // ─── Timer ────────────────────────────────────────────────────────────────
  static const int questionTimerSeconds = 20;
  static const int duelTimerSeconds = 20;

  // ─── Streak Thresholds ────────────────────────────────────────────────────
  static const int streakThreshold1 = 3;
  static const int streakThreshold2 = 5;
  static const int streakThreshold3 = 10;

  // ─── Booster Rarity Rates ─────────────────────────────────────────────────
  static const double communeRate = 0.60;
  static const double rareRate = 0.25;
  static const double epiqueRate = 0.12;
  static const double legendaireRate = 0.03;
  static const int boosterCardCount = 3;

  // ─── Grind Requirements ───────────────────────────────────────────────────
  static const int grindDuelWinsNewSchool = 20;
  static const int grindSoloCorrectNewSchool = 150;

  // ─── Quiz ─────────────────────────────────────────────────────────────────
  static const int questionsPerSession = 10;
  static const int dailyChallengeQuestions = 5;

  // ─── Duel ─────────────────────────────────────────────────────────────────
  static const int duelQuestions = 10;
  static const int duelLobbyTimeoutSeconds = 60;
  static const int duelCodeLength = 6;

  // ─── Subscription ─────────────────────────────────────────────────────────
  static const String monthlyProductId = 'app_rap_monthly';
  static const String yearlyProductId = 'app_rap_yearly';
  static const String monthlyPriceDisplay = '4,99 €/mois';
  static const String yearlyPriceDisplay = '39,99 €/an';

  // ─── Firestore Collections ────────────────────────────────────────────────
  static const String usersCollection = 'users';
  static const String packsCollection = 'packs';
  static const String questionsCollection = 'questions';
  static const String cardsCollection = 'cards';
  static const String duelsCollection = 'duels';
  static const String dailyChallengesCollection = 'dailyChallenges';
  static const String transactionsCollection = 'transactions';
  static const String boostersCollection = 'boosters';
  static const String leaderboardCollection = 'leaderboard';
}
