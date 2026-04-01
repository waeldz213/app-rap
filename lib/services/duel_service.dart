// Mock duel service — Firebase désactivé pour les tests en local
import '../models/duel_model.dart';
import 'mock_data.dart';

class DuelService {
  Future<DuelModel> createDuel({
    required String initiatorUserId,
    required String initiatorDisplayName,
    required String packId,
    required String packTitle,
    required List<String> questionIds,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return DuelModel(
      id: 'duel-mock-${DateTime.now().millisecondsSinceEpoch}',
      packId: packId,
      packTitle: packTitle,
      inviteCode: 'MOCK42',
      initiatorUserId: initiatorUserId,
      initiatorDisplayName: initiatorDisplayName,
      status: DuelStatus.waiting,
      questionIds: questionIds,
      createdAt: DateTime.now(),
    );
  }

  Future<DuelModel?> joinDuelByCode({
    required String inviteCode,
    required String opponentUserId,
    required String opponentDisplayName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final duel = MockData.duels.firstWhere(
      (d) => d.inviteCode == inviteCode,
      orElse: () => MockData.duels.first,
    );
    return DuelModel(
      id: duel.id,
      packId: duel.packId,
      packTitle: duel.packTitle,
      inviteCode: duel.inviteCode,
      initiatorUserId: duel.initiatorUserId,
      initiatorDisplayName: duel.initiatorDisplayName,
      opponentUserId: opponentUserId,
      opponentDisplayName: opponentDisplayName,
      status: DuelStatus.active,
      questionIds: duel.questionIds,
      createdAt: duel.createdAt,
    );
  }

  Future<void> submitAnswers({
    required String duelId,
    required String userId,
    required String initiatorUserId,
    required List<DuelAnswer> answers,
    required int totalScore,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // No-op en mode mock
  }

  Stream<DuelModel?> listenToDuel(String duelId) {
    return Stream.value(
      MockData.duels.firstWhere(
        (d) => d.id == duelId,
        orElse: () => MockData.duels.first,
      ),
    );
  }

  Future<List<DuelModel>> getUserDuels(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.duels;
  }
}
