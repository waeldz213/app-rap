import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/question_model.dart';
import '../services/quiz_service.dart';
import '../services/scoring_service.dart';
import 'auth_provider.dart';

final quizServiceProvider = Provider<QuizService>((ref) {
  return QuizService(ref.watch(firestoreServiceProvider));
});

final scoringServiceProvider = Provider<ScoringService>((ref) {
  return ScoringService(ref.watch(firestoreServiceProvider));
});

class QuizState {
  final List<QuestionModel> questions;
  final int currentIndex;
  final List<String?> answers;
  final int score;
  final int streak;
  final DateTime? startTime;
  final bool isComplete;
  final bool isLoading;
  final String? error;

  const QuizState({
    this.questions = const [],
    this.currentIndex = 0,
    this.answers = const [],
    this.score = 0,
    this.streak = 0,
    this.startTime,
    this.isComplete = false,
    this.isLoading = false,
    this.error,
  });

  QuizState copyWith({
    List<QuestionModel>? questions,
    int? currentIndex,
    List<String?>? answers,
    int? score,
    int? streak,
    DateTime? startTime,
    bool? isComplete,
    bool? isLoading,
    String? error,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      score: score ?? this.score,
      streak: streak ?? this.streak,
      startTime: startTime ?? this.startTime,
      isComplete: isComplete ?? this.isComplete,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  QuestionModel? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;

  int get correctAnswers =>
      answers.asMap().entries.where((entry) {
        final idx = entry.key;
        final answer = entry.value;
        if (idx >= questions.length || answer == null) return false;
        return answer == questions[idx].correctAnswer;
      }).length;
}

class QuizNotifier extends StateNotifier<QuizState> {
  final QuizService _quizService;
  final ScoringService _scoringService;
  final String _userId;

  QuizNotifier(this._quizService, this._scoringService, this._userId)
      : super(const QuizState());

  Future<void> loadQuestions(String packId, {int limit = 10}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final questions =
          await _quizService.getQuestionsForPack(packId, limit: limit);
      state = state.copyWith(
        questions: questions,
        answers: List.filled(questions.length, null),
        currentIndex: 0,
        score: 0,
        streak: 0,
        startTime: DateTime.now(),
        isComplete: false,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void answerQuestion(String answer, int secondsUsed) {
    if (state.currentQuestion == null) return;
    final isCorrect = answer == state.currentQuestion!.correctAnswer;
    final newStreak = isCorrect ? state.streak + 1 : 0;
    final questionScore = isCorrect
        ? _scoringService.calculateQuizScore(
            correctAnswers: 1,
            totalTime: secondsUsed,
            streak: state.streak,
            hasEquippedCard: false,
          )
        : 0;

    final newAnswers = List<String?>.from(state.answers);
    newAnswers[state.currentIndex] = answer;

    state = state.copyWith(
      answers: newAnswers,
      score: state.score + questionScore,
      streak: newStreak,
    );
  }

  void nextQuestion() {
    final nextIndex = state.currentIndex + 1;
    if (nextIndex >= state.questions.length) {
      completeQuiz();
    } else {
      state = state.copyWith(currentIndex: nextIndex);
    }
  }

  Future<void> completeQuiz(
      {String? packId, bool hasEquippedCard = false}) async {
    state = state.copyWith(isComplete: true);
    try {
      await _quizService.updateUserStatsAfterQuiz(
        _userId,
        state.correctAnswers,
        state.score,
      );
    } catch (_) {
      // Non-critical: proceed even if stat update fails
    }
  }

  void reset() {
    state = const QuizState();
  }
}

final quizNotifierProvider =
    StateNotifierProvider.autoDispose<QuizNotifier, QuizState>((ref) {
  final quizService = ref.watch(quizServiceProvider);
  final scoringService = ref.watch(scoringServiceProvider);
  final authService = ref.watch(authServiceProvider);
  final userId = authService.currentUser?.uid ?? '';
  return QuizNotifier(quizService, scoringService, userId);
});
