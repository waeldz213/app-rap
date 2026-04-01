import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/daily_challenge_model.dart';
import '../config/constants.dart';

class DailyChallengeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _todayKey {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<DailyChallengeModel?> getTodaysChallenge(String userId) async {
    final doc = await _firestore
        .collection(AppConstants.dailyChallengesCollection)
        .doc(_todayKey)
        .get();

    if (!doc.exists) return null;

    final challenge = DailyChallengeModel.fromJson(doc.data()!, doc.id);

    // Check if user has completed
    final completionDoc = await _firestore
        .collection(AppConstants.dailyChallengesCollection)
        .doc(_todayKey)
        .collection('completions')
        .doc(userId)
        .get();

    return challenge.copyWith(isCompleted: completionDoc.exists);
  }

  Future<void> markChallengeCompleted({
    required String userId,
    required String challengeId,
    required int score,
    required int correctAnswers,
  }) async {
    final batch = _firestore.batch();

    // Mark completion
    final completionRef = _firestore
        .collection(AppConstants.dailyChallengesCollection)
        .doc(challengeId)
        .collection('completions')
        .doc(userId);

    batch.set(completionRef, {
      'userId': userId,
      'score': score,
      'correctAnswers': correctAnswers,
      'completedAt': FieldValue.serverTimestamp(),
    });

    // Update user stats and reward
    final challengeDoc = await _firestore
        .collection(AppConstants.dailyChallengesCollection)
        .doc(challengeId)
        .get();

    if (challengeDoc.exists) {
      final data = challengeDoc.data()!;
      final bonusCoins = data['bonusCoins'] as int? ?? 30;
      final bonusXp = data['bonusXp'] as int? ?? 150;

      final userRef = _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId);

      batch.update(userRef, {
        'coins': FieldValue.increment(bonusCoins),
        'xp': FieldValue.increment(bonusXp),
        'stats.dailyChallengesCompleted': FieldValue.increment(1),
      });
    }

    await batch.commit();
  }
}
