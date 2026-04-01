import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/question_model.dart';
import '../services/quiz_service.dart';
import '../services/scoring_service.dart';
import '../config/constants.dart';

class QuizState {
  final List<QuestionModel> questions;
  final int currentIndex;
  final int score;
  final int streak;
  final int correctAnswers;
  final List<String?> selectedAnswers;
  final bool isFinished;
  final bool isLoading;
  final String? error;
  final int timerSeconds;

  const QuizState({
    this.questions = const [],
    this.currentIndex = 0,
    this.score = 0,
    this.streak = 0,
    this.correctAnswers = 0,
    this.selectedAnswers = const [],
    this.isFinished = false,
    this.isLoading = true,
    this.error,
    this.timerSeconds = AppConstants.questionTimerSeconds,
  });

  QuestionModel? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;

  bool get hasNext => currentIndex < questions.length - 1;

  QuizState copyWith({
    List<QuestionModel>? questions,
    int? currentIndex,
    int? score,
    int? streak,
    int? correctAnswers,
    List<String?>? selectedAnswers,
    bool? isFinished,
    bool? isLoading,
    String? error,
    int? timerSeconds,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      streak: streak ?? this.streak,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      isFinished: isFinished ?? this.isFinished,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      timerSeconds: timerSeconds ?? this.timerSeconds,
    );
  }
}

class QuizNotifier extends StateNotifier<QuizState> {
  final QuizService _quizService;
  final ScoringService _scoringService;
  Timer? _timer;
  DateTime? _questionStartTime;

  QuizNotifier(this._quizService, this._scoringService)
      : super(const QuizState());

  Future<void> loadQuiz(String packId) async {
    state = const QuizState(isLoading: true);
    try {
      final questions = await _quizService.getQuestionsForPack(packId);
      state = QuizState(
        questions: questions,
        selectedAnswers: List.filled(questions.length, null),
        isLoading: false,
      );
      _startTimer();
    } catch (e) {
      state = QuizState(isLoading: false, error: e.toString());
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _questionStartTime = DateTime.now();
    state = state.copyWith(timerSeconds: AppConstants.questionTimerSeconds);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timerSeconds <= 0) {
        timer.cancel();
        _onTimeUp();
      } else {
        state = state.copyWith(timerSeconds: state.timerSeconds - 1);
      }
    });
  }

  void _onTimeUp() {
    if (state.currentQuestion == null) return;
    // Auto-select wrong answer on timeout
    answerQuestion(null);
  }

  void answerQuestion(String? answer) {
    _timer?.cancel();
    final question = state.currentQuestion;
    if (question == null) return;

    final timeSpentMs = _questionStartTime != null
        ? DateTime.now().difference(_questionStartTime!).inMilliseconds
        : AppConstants.questionTimerSeconds * 1000;

    final isCorrect = answer == question.correctAnswer;
    final newStreak = isCorrect ? state.streak + 1 : 0;

    final scoring = _scoringService.calculateScore(
      isCorrect: isCorrect,
      timeSpentMs: timeSpentMs,
      streak: newStreak,
    );

    final newAnswers = List<String?>.from(state.selectedAnswers);
    newAnswers[state.currentIndex] = answer;

    state = state.copyWith(
      selectedAnswers: newAnswers,
      score: state.score + scoring.total,
      streak: newStreak,
      correctAnswers:
          state.correctAnswers + (isCorrect ? 1 : 0),
    );
  }

  void nextQuestion() {
    if (state.hasNext) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
      _startTimer();
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    _timer?.cancel();
    state = state.copyWith(isFinished: true);
  }

  void reset() {
    _timer?.cancel();
    state = const QuizState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final quizServiceProvider = Provider<QuizService>((ref) => QuizService());
final scoringServiceProvider =
    Provider<ScoringService>((ref) => ScoringService());

final quizProvider =
    StateNotifierProvider.autoDispose<QuizNotifier, QuizState>((ref) {
  return QuizNotifier(
    ref.watch(quizServiceProvider),
    ref.watch(scoringServiceProvider),
  );
});
