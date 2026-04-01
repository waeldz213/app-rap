import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/quiz_provider.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import 'widgets/question_card.dart';
import 'widgets/answer_button.dart';
import 'widgets/timer_widget.dart';
import 'widgets/streak_indicator.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final String packId;

  const QuizScreen({super.key, required this.packId});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  String? _selectedAnswer;
  bool _hasAnswered = false;
  int _answerTime = AppConstants.questionTimeLimit;
  int _questionStartTime = 0;
  Timer? _nextQuestionTimer;

  @override
  void initState() {
    super.initState();
    _questionStartTime = DateTime.now().millisecondsSinceEpoch;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(quizNotifierProvider.notifier).loadQuestions(widget.packId);
    });
  }

  @override
  void dispose() {
    _nextQuestionTimer?.cancel();
    super.dispose();
  }

  void _onAnswer(String answer) {
    if (_hasAnswered) return;

    final secondsUsed = AppConstants.questionTimeLimit - _answerTime;
    setState(() {
      _selectedAnswer = answer;
      _hasAnswered = true;
    });

    ref
        .read(quizNotifierProvider.notifier)
        .answerQuestion(answer, secondsUsed);

    _nextQuestionTimer = Timer(const Duration(milliseconds: 1200), () {
      _goNext();
    });
  }

  void _onTimeout() {
    if (!_hasAnswered) {
      _onAnswer('');
    }
  }

  void _goNext() {
    final state = ref.read(quizNotifierProvider);
    setState(() {
      _selectedAnswer = null;
      _hasAnswered = false;
      _answerTime = AppConstants.questionTimeLimit;
      _questionStartTime = DateTime.now().millisecondsSinceEpoch;
    });

    if (state.currentIndex >= state.questions.length - 1) {
      ref.read(quizNotifierProvider.notifier).completeQuiz();
      context.push(
        '/quiz/${widget.packId}/result',
        extra: {
          'score': state.score,
          'correctAnswers': state.correctAnswers,
          'totalQuestions': state.questions.length,
        },
      );
    } else {
      ref.read(quizNotifierProvider.notifier).nextQuestion();
    }
  }

  AnswerState _getAnswerState(String option) {
    if (!_hasAnswered) return AnswerState.idle;
    final quizState = ref.read(quizNotifierProvider);
    final correct = quizState.currentQuestion?.correctAnswer;
    if (option == correct) return AnswerState.correct;
    if (option == _selectedAnswer) return AnswerState.wrong;
    return AnswerState.idle;
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizNotifierProvider);

    if (quizState.isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (quizState.error != null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(),
        body: Center(
          child: Text(
            'Erreur: ${quizState.error}',
            style: const TextStyle(color: AppTheme.error),
          ),
        ),
      );
    }

    final question = quizState.currentQuestion;
    if (question == null) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            ref.read(quizNotifierProvider.notifier).reset();
            context.pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: StreakIndicator(streak: quizState.streak),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Progress bar
              LinearProgressIndicator(
                value: (quizState.currentIndex + 1) /
                    quizState.questions.length,
                backgroundColor: AppTheme.surfaceVariant,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                minHeight: 4,
              ),
              const SizedBox(height: 20),
              // Timer and score
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TimerWidget(
                    key: ValueKey(quizState.currentIndex),
                    durationSeconds: AppConstants.questionTimeLimit,
                    onTimeout: _onTimeout,
                    onTick: (seconds) => setState(() => _answerTime = seconds),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${quizState.score} pts',
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Q ${quizState.currentIndex + 1}/${quizState.questions.length}',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Question card
              QuestionCard(
                key: ValueKey(question.id),
                question: question,
                questionNumber: quizState.currentIndex + 1,
                totalQuestions: quizState.questions.length,
              ),
              const SizedBox(height: 20),
              // Answer options
              Expanded(
                child: ListView.separated(
                  itemCount: question.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final option = question.options[index];
                    return AnswerButton(
                      key: ValueKey('${question.id}_$index'),
                      text: option,
                      state: _getAnswerState(option),
                      onTap: _hasAnswered ? null : () => _onAnswer(option),
                      index: index,
                    );
                  },
                ),
              ),
              if (_hasAnswered && question.explanation != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline,
                          color: AppTheme.secondary, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          question.explanation!,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
