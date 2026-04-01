// Mock quiz service — Firebase désactivé pour les tests en local
import '../models/question_model.dart';
import 'mock_data.dart';

class QuizService {
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

  Future<List<QuestionModel>> getQuestionsByIds(
    String packId,
    List<String> ids,
  ) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return MockData.questions.where((q) => ids.contains(q.id)).toList();
  }
}
