import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/daily_challenge_model.dart';
import 'firestore_service.dart';

class DailyChallengeService {
  final FirestoreService _firestoreService;

  DailyChallengeService(this._firestoreService);

  String get _todayKey =>
      DateTime.now().toIso8601String().split('T')[0];

  Future<DailyChallengeModel?> getTodayChallenge() async {
    final doc = await _firestoreService.dailyChallenges.doc(_todayKey).get();
    if (!doc.exists) return null;
    final data = doc.data() as Map<String, dynamic>;
    return DailyChallengeModel.fromJson({...data, 'id': doc.id});
  }

  Future<void> completeChallenge(String userId, String challengeId) async {
    final batch = _firestoreService.db.batch();

    final challengeRef =
        _firestoreService.dailyChallenges.doc(challengeId);
    batch.update(challengeRef, {
      'completedByUserIds': FieldValue.arrayUnion([userId]),
    });

    final userRef = _firestoreService.users.doc(userId);
    batch.update(userRef, {
      'coins': FieldValue.increment(25),
      'xp': FieldValue.increment(50),
      'lastPlayedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  Future<bool> hasUserCompletedToday(String userId) async {
    final challenge = await getTodayChallenge();
    if (challenge == null) return false;
    return challenge.completedByUserIds.contains(userId);
  }
}
