import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/duel_model.dart';
import 'firestore_service.dart';

class DuelService {
  final FirestoreService _firestoreService;

  DuelService(this._firestoreService);

  Future<DuelModel> createDuel({
    required String initiatorUserId,
    required List<String> questionIds,
  }) async {
    final docRef = _firestoreService.duels.doc();
    final now = DateTime.now();

    final duel = DuelModel(
      id: docRef.id,
      initiatorUserId: initiatorUserId,
      status: DuelStatus.waiting,
      questionIds: questionIds,
      initiatorAnswers: const [],
      opponentAnswers: const [],
      initiatorScore: 0,
      opponentScore: 0,
      createdAt: now,
    );

    await docRef.set(duel.toJson());
    return duel;
  }

  Future<DuelModel?> joinDuel({
    required String duelId,
    required String opponentUserId,
  }) async {
    final docRef = _firestoreService.duels.doc(duelId);
    await docRef.update({
      'opponentUserId': opponentUserId,
      'status': DuelStatus.active.toJson(),
    });

    final doc = await docRef.get();
    if (!doc.exists) return null;
    final data = doc.data() as Map<String, dynamic>;
    return DuelModel.fromJson({...data, 'id': doc.id});
  }

  Future<void> submitAnswer({
    required String duelId,
    required String userId,
    required DuelAnswer answer,
    required bool isInitiator,
  }) async {
    final docRef = _firestoreService.duels.doc(duelId);

    if (isInitiator) {
      await docRef.update({
        'initiatorAnswers': FieldValue.arrayUnion([answer.toJson()]),
        'initiatorScore': FieldValue.increment(answer.scoreEarned),
      });
    } else {
      await docRef.update({
        'opponentAnswers': FieldValue.arrayUnion([answer.toJson()]),
        'opponentScore': FieldValue.increment(answer.scoreEarned),
      });
    }
  }

  Future<void> completeDuel({
    required String duelId,
    required String winnerId,
    required int initiatorScore,
    required int opponentScore,
  }) async {
    await _firestoreService.duels.doc(duelId).update({
      'status': DuelStatus.completed.toJson(),
      'winnerId': winnerId,
      'initiatorScore': initiatorScore,
      'opponentScore': opponentScore,
      'completedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<DuelModel> duelStream(String duelId) {
    return _firestoreService.duels
        .doc(duelId)
        .snapshots()
        .where((doc) => doc.exists)
        .map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return DuelModel.fromJson({...data, 'id': doc.id});
    });
  }

  Future<List<DuelModel>> getUserActiveDuels(String userId) async {
    final initiatorSnapshot = await _firestoreService.duels
        .where('initiatorUserId', isEqualTo: userId)
        .where('status', whereIn: ['waiting', 'active'])
        .orderBy('createdAt', descending: true)
        .get();

    final opponentSnapshot = await _firestoreService.duels
        .where('opponentUserId', isEqualTo: userId)
        .where('status', whereIn: ['waiting', 'active'])
        .orderBy('createdAt', descending: true)
        .get();

    final duels = [
      ...initiatorSnapshot.docs,
      ...opponentSnapshot.docs,
    ].map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return DuelModel.fromJson({...data, 'id': doc.id});
    }).toList();

    duels.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return duels;
  }

  Future<List<DuelModel>> getUserPendingDuels() async {
    final snapshot = await _firestoreService.duels
        .where('status', isEqualTo: 'waiting')
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return DuelModel.fromJson({...data, 'id': doc.id});
    }).toList();
  }
}
