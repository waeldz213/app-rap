// Mock pack service — Firebase désactivé pour les tests en local
import '../models/pack_model.dart';
import '../models/question_model.dart';
import 'mock_data.dart';

class PackService {
  Future<List<PackModel>> getPacks() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.packs;
  }

  Future<PackModel?> getPackById(String packId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return MockData.packs.firstWhere((p) => p.id == packId);
    } catch (_) {
      return null;
    }
  }

  Future<List<QuestionModel>> getQuestionsForPack(
    String packId, {
    int limit = 5,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final questions = MockData.questions
        .where((q) => q.packId == packId)
        .toList();
    if (questions.isEmpty) {
      return MockData.questions.take(limit).toList();
    }
    return questions.take(limit).toList();
  }
}
