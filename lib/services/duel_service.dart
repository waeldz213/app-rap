import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/duel_model.dart';
import '../config/constants.dart';

class DuelService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rng = Random();
    return List.generate(AppConstants.duelCodeLength,
        (index) => chars[rng.nextInt(chars.length)]).join();
  }

  Future<DuelModel> createDuel({
    required String initiatorUserId,
    required String initiatorDisplayName,
    required String packId,
    required String packTitle,
    required List<String> questionIds,
  }) async {
    final inviteCode = _generateInviteCode();
    final now = DateTime.now();

    final data = {
      'packId': packId,
      'packTitle': packTitle,
      'inviteCode': inviteCode,
      'initiatorUserId': initiatorUserId,
      'initiatorDisplayName': initiatorDisplayName,
      'opponentUserId': null,
      'opponentDisplayName': null,
      'status': DuelStatus.waiting.value,
      'questionIds': questionIds,
      'initiatorAnswers': [],
      'opponentAnswers': [],
      'initiatorScore': 0,
      'opponentScore': 0,
      'winnerId': null,
      'createdAt': Timestamp.fromDate(now),
      'resolvedAt': null,
    };

    final ref = await _firestore
        .collection(AppConstants.duelsCollection)
        .add(data);

    return DuelModel(
      id: ref.id,
      packId: packId,
      packTitle: packTitle,
      inviteCode: inviteCode,
      initiatorUserId: initiatorUserId,
      initiatorDisplayName: initiatorDisplayName,
      status: DuelStatus.waiting,
      questionIds: questionIds,
      createdAt: now,
    );
  }

  Future<DuelModel?> joinDuelByCode({
    required String inviteCode,
    required String opponentUserId,
    required String opponentDisplayName,
  }) async {
    final snap = await _firestore
        .collection(AppConstants.duelsCollection)
        .where('inviteCode', isEqualTo: inviteCode)
        .where('status', isEqualTo: DuelStatus.waiting.value)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;

    final doc = snap.docs.first;
    final duelData = doc.data();

    if (duelData['initiatorUserId'] == opponentUserId) return null;

    await doc.reference.update({
      'opponentUserId': opponentUserId,
      'opponentDisplayName': opponentDisplayName,
      'status': DuelStatus.active.value,
    });

    return DuelModel.fromJson(
      {...duelData, 'opponentUserId': opponentUserId, 'opponentDisplayName': opponentDisplayName, 'status': DuelStatus.active.value},
      doc.id,
    );
  }

  Future<void> submitAnswers({
    required String duelId,
    required String userId,
    required String initiatorUserId,
    required List<DuelAnswer> answers,
    required int totalScore,
  }) async {
    final isInitiator = userId == initiatorUserId;
    final field = isInitiator ? 'initiatorAnswers' : 'opponentAnswers';
    final scoreField = isInitiator ? 'initiatorScore' : 'opponentScore';

    final ref = _firestore.collection(AppConstants.duelsCollection).doc(duelId);
    final docSnap = await ref.get();
    if (!docSnap.exists) return;

    final data = docSnap.data()!;
    final otherScoreField = isInitiator ? 'opponentScore' : 'initiatorScore';
    final otherAnswers = isInitiator ? 'opponentAnswers' : 'initiatorAnswers';
    final otherAnswersList = data[otherAnswers] as List? ?? [];

    // If both players have submitted, mark as completed
    final bothCompleted = otherAnswersList.isNotEmpty;

    await ref.update({
      field: answers.map((a) => a.toJson()).toList(),
      scoreField: totalScore,
      if (bothCompleted) 'status': DuelStatus.completed.value,
    });
  }

  Stream<DuelModel?> listenToDuel(String duelId) {
    return _firestore
        .collection(AppConstants.duelsCollection)
        .doc(duelId)
        .snapshots()
        .map((snap) {
      if (!snap.exists) return null;
      return DuelModel.fromJson(snap.data()!, snap.id);
    });
  }

  Future<List<DuelModel>> getUserDuels(String userId) async {
    final initiatorSnap = await _firestore
        .collection(AppConstants.duelsCollection)
        .where('initiatorUserId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();

    final opponentSnap = await _firestore
        .collection(AppConstants.duelsCollection)
        .where('opponentUserId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();

    final duels = [
      ...initiatorSnap.docs
          .map((d) => DuelModel.fromJson(d.data(), d.id)),
      ...opponentSnap.docs
          .map((d) => DuelModel.fromJson(d.data(), d.id)),
    ];

    duels.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return duels;
  }
}
