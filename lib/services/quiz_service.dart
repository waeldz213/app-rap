import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question_model.dart';
import 'firestore_service.dart';

class QuizService {
  final FirestoreService _firestoreService;

  QuizService(this._firestoreService);

  Future<List<QuestionModel>> getQuestionsForPack(
    String packId, {
    int limit = 10,
  }) async {
    final snapshot = await _firestoreService.questions
        .where('packId', isEqualTo: packId)
        .where('isActive', isEqualTo: true)
        .limit(limit)
        .get();

    final questions = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return QuestionModel.fromJson({...data, 'id': doc.id});
    }).toList();

    questions.shuffle();
    return questions;
  }

  Future<void> submitQuizResult({
    required String userId,
    required String packId,
    required int score,
    required int correctAnswers,
    required int totalQuestions,
  }) async {
    final batch = _firestoreService.db.batch();

    final resultRef = _firestoreService.db
        .collection('quizResults')
        .doc();

    batch.set(resultRef, {
      'userId': userId,
      'packId': packId,
      'score': score,
      'correctAnswers': correctAnswers,
      'totalQuestions': totalQuestions,
      'completedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
    await updateUserStatsAfterQuiz(userId, correctAnswers, score);
  }

  Future<void> updateUserStatsAfterQuiz(
    String userId,
    int correctAnswers,
    int score,
  ) async {
    await _firestoreService.users.doc(userId).update({
      'stats.totalGamesPlayed': FieldValue.increment(1),
      'stats.totalCorrectAnswers': FieldValue.increment(correctAnswers),
      'xp': FieldValue.increment(score ~/ 10),
      'lastPlayedAt': FieldValue.serverTimestamp(),
    });
  }
}
