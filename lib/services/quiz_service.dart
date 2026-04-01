import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question_model.dart';
import '../config/constants.dart';

class QuizService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QuestionModel>> getQuestionsForPack(
    String packId, {
    int limit = AppConstants.questionsPerSession,
  }) async {
    final snap = await _firestore
        .collection(AppConstants.packsCollection)
        .doc(packId)
        .collection(AppConstants.questionsCollection)
        .where('isActive', isEqualTo: true)
        .limit(limit * 3)
        .get();

    final questions = snap.docs
        .map((doc) => QuestionModel.fromJson(doc.data(), doc.id))
        .toList();

    questions.shuffle();
    return questions.take(limit).toList();
  }

  Future<List<QuestionModel>> getQuestionsByIds(
    String packId,
    List<String> ids,
  ) async {
    if (ids.isEmpty) return [];
    final futures = ids.map((id) => _firestore
        .collection(AppConstants.packsCollection)
        .doc(packId)
        .collection(AppConstants.questionsCollection)
        .doc(id)
        .get());

    final snaps = await Future.wait(futures);
    return snaps
        .where((s) => s.exists)
        .map((s) => QuestionModel.fromJson(s.data()!, s.id))
        .toList();
  }
}
