// Mock daily challenge service — Firebase désactivé pour les tests en local
import '../models/daily_challenge_model.dart';
import 'mock_data.dart';

class DailyChallengeService {
  Future<DailyChallengeModel?> getTodaysChallenge(String userId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    // Toujours jouable en mode mock
    return MockData.dailyChallenge.copyWith(isCompleted: false);
  }

  Future<void> markChallengeCompleted({
    required String userId,
    required String challengeId,
    required int score,
    required int correctAnswers,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // No-op en mode mock
  }
}
