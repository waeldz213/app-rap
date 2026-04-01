import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/duel_model.dart';
import '../models/question_model.dart';
import '../services/duel_service.dart';
import '../services/quiz_service.dart';
import 'auth_provider.dart';
import 'quiz_provider.dart';

final duelServiceProvider = Provider<DuelService>((ref) {
  return DuelService(ref.watch(firestoreServiceProvider));
});

final activeDuelProvider =
    StreamProvider.autoDispose.family<DuelModel, String>((ref, duelId) {
  return ref.watch(duelServiceProvider).duelStream(duelId);
});

class DuelGameState {
  final DuelModel? duel;
  final List<QuestionModel> questions;
  final int currentQuestionIndex;
  final String? selectedAnswer;
  final bool hasAnswered;
  final bool isLoading;
  final String? error;

  const DuelGameState({
    this.duel,
    this.questions = const [],
    this.currentQuestionIndex = 0,
    this.selectedAnswer,
    this.hasAnswered = false,
    this.isLoading = false,
    this.error,
  });

  QuestionModel? get currentQuestion =>
      currentQuestionIndex < questions.length
          ? questions[currentQuestionIndex]
          : null;

  DuelGameState copyWith({
    DuelModel? duel,
    List<QuestionModel>? questions,
    int? currentQuestionIndex,
    String? selectedAnswer,
    bool? hasAnswered,
    bool? isLoading,
    String? error,
  }) {
    return DuelGameState(
      duel: duel ?? this.duel,
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      hasAnswered: hasAnswered ?? this.hasAnswered,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class DuelNotifier extends StateNotifier<DuelGameState> {
  final DuelService _duelService;
  final QuizService _quizService;
  final String _userId;

  DuelNotifier(this._duelService, this._quizService, this._userId)
      : super(const DuelGameState());

  Future<DuelModel> createDuel(List<String> questionIds) async {
    state = state.copyWith(isLoading: true);
    final duel = await _duelService.createDuel(
      initiatorUserId: _userId,
      questionIds: questionIds,
    );
    state = state.copyWith(duel: duel, isLoading: false);
    return duel;
  }

  Future<void> loadQuestionsForDuel(DuelModel duel) async {
    state = state.copyWith(isLoading: true);
    try {
      final questions = <QuestionModel>[];
      for (final qId in duel.questionIds) {
        final snapshot = await _quizService.getQuestionsForPack(
          qId,
          limit: 1,
        );
        if (snapshot.isNotEmpty) questions.add(snapshot.first);
      }
      state = state.copyWith(questions: questions, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> submitAnswer({
    required String duelId,
    required String answer,
    required int secondsUsed,
    required bool isInitiator,
  }) async {
    if (state.currentQuestion == null) return;
    final isCorrect = answer == state.currentQuestion!.correctAnswer;
    final duelAnswer = DuelAnswer(
      questionId: state.currentQuestion!.id,
      selectedAnswer: answer,
      isCorrect: isCorrect,
      timeSpent: secondsUsed,
      scoreEarned: isCorrect ? 200 : 0,
    );

    state = state.copyWith(selectedAnswer: answer, hasAnswered: true);
    await _duelService.submitAnswer(
      duelId: duelId,
      userId: _userId,
      answer: duelAnswer,
      isInitiator: isInitiator,
    );
  }

  void nextQuestion() {
    state = state.copyWith(
      currentQuestionIndex: state.currentQuestionIndex + 1,
      selectedAnswer: null,
      hasAnswered: false,
    );
  }

  void reset() {
    state = const DuelGameState();
  }
}

final duelNotifierProvider =
    StateNotifierProvider.autoDispose<DuelNotifier, DuelGameState>((ref) {
  final duelService = ref.watch(duelServiceProvider);
  final quizService = ref.watch(quizServiceProvider);
  final authService = ref.watch(authServiceProvider);
  final userId = authService.currentUser?.uid ?? '';
  return DuelNotifier(duelService, quizService, userId);
});
