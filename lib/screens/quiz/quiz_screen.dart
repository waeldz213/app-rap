import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/user_provider.dart';
import '../../services/scoring_service.dart';
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
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(quizProvider.notifier).loadQuiz(widget.packId));
  }

  void _answer(String? choice) {
    if (_answered) return;
    setState(() {
      _selectedAnswer = choice;
      _answered = true;
    });
    ref.read(quizProvider.notifier).answerQuestion(choice);

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      final quiz = ref.read(quizProvider);
      if (quiz.hasNext) {
        setState(() {
          _selectedAnswer = null;
          _answered = false;
        });
        ref.read(quizProvider.notifier).nextQuestion();
      } else {
        ref.read(quizProvider.notifier).nextQuestion();
        _navigateToResult();
      }
    });
  }

  void _navigateToResult() {
    final quiz = ref.read(quizProvider);
    final user = ref.read(userModelProvider).valueOrNull;
    final scoring = ScoringService();
    final xp = scoring.calculateXpGained(
      correctAnswers: quiz.correctAnswers,
      isDaily: false,
    );
    final coins = scoring.calculateCoinsGained(
      correctAnswers: quiz.correctAnswers,
      isDaily: false,
    );

    context.go(
      '/quiz/${widget.packId}/result',
      extra: {
        'score': quiz.score,
        'total': quiz.questions.length,
        'xpGained': xp,
        'coinsGained': coins,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final quiz = ref.watch(quizProvider);

    if (quiz.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (quiz.error != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            'Erreur: ${quiz.error}',
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      );
    }

    final question = quiz.currentQuestion;
    if (question == null) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            ref.read(quizProvider.notifier).reset();
            context.go('/packs');
          },
        ),
        title: Text(
          'Question ${quiz.currentIndex + 1}/${quiz.questions.length}',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${quiz.score} pts',
                style: const TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (quiz.currentIndex + 1) / quiz.questions.length,
                backgroundColor: AppColors.surfaceVariant,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TimerWidget(
                  seconds: quiz.timerSeconds,
                  maxSeconds: AppConstants.questionTimerSeconds,
                ),
                StreakIndicator(streak: quiz.streak),
              ],
            ),
            const SizedBox(height: 16),
            QuestionCard(
              question: question,
              questionNumber: quiz.currentIndex + 1,
              total: quiz.questions.length,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: question.choices.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final choice = question.choices[index];
                  AnswerState state = AnswerState.idle;
                  if (_answered) {
                    if (choice == question.correctAnswer) {
                      state = AnswerState.correct;
                    } else if (choice == _selectedAnswer) {
                      state = AnswerState.wrong;
                    }
                  }
                  return AnswerButton(
                    text: choice,
                    state: state,
                    index: index,
                    onPressed: () => _answer(choice),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
