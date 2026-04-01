import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../models/duel_model.dart';
import '../../providers/duel_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/quiz_provider.dart';
import '../quiz/widgets/question_card.dart';
import '../quiz/widgets/answer_button.dart';
import '../quiz/widgets/timer_widget.dart';

class DuelScreen extends ConsumerStatefulWidget {
  final String duelId;

  const DuelScreen({super.key, required this.duelId});

  @override
  ConsumerState<DuelScreen> createState() => _DuelScreenState();
}

class _DuelScreenState extends ConsumerState<DuelScreen> {
  String? _selectedAnswer;
  bool _answered = false;
  int _questionIndex = 0;
  int _myScore = 0;
  int _myCorrect = 0;

  void _answer(String? choice, String correctAnswer) {
    if (_answered) return;
    setState(() {
      _selectedAnswer = choice;
      _answered = true;
    });

    final isCorrect = choice == correctAnswer;
    if (isCorrect) {
      setState(() {
        _myScore += 100;
        _myCorrect++;
      });
    }

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      final duel = ref.read(duelStreamProvider(widget.duelId)).valueOrNull;
      if (duel == null) return;

      if (_questionIndex < duel.questionIds.length - 1) {
        setState(() {
          _questionIndex++;
          _selectedAnswer = null;
          _answered = false;
        });
      } else {
        _submitAndNavigate(duel);
      }
    });
  }

  Future<void> _submitAndNavigate(DuelModel duel) async {
    final userId = ref.read(currentUserProvider)?.uid ?? '';
    await ref.read(duelServiceProvider).submitAnswers(
          duelId: widget.duelId,
          userId: userId,
          initiatorUserId: duel.initiatorUserId,
          answers: [],
          totalScore: _myScore,
        );

    if (mounted) {
      context.go(
        '/duel/${widget.duelId}/result',
        extra: {
          'myScore': _myScore,
          'opponentScore': 0,
          'winnerId': '',
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final duelAsync = ref.watch(duelStreamProvider(widget.duelId));
    final quiz = ref.watch(quizProvider);
    final userId = ref.watch(currentUserProvider)?.uid ?? '';

    return duelAsync.when(
      data: (duel) {
        if (duel == null) {
          return const Scaffold(
            body: Center(child: Text('Duel introuvable')),
          );
        }

        if (duel.status == DuelStatus.waiting) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'En attente de l\'adversaire...',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          );
        }

        final isInitiator = duel.initiatorUserId == userId;
        final opponentName = isInitiator
            ? duel.opponentDisplayName ?? 'Adversaire'
            : duel.initiatorDisplayName;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text('vs $opponentName'),
            leading: const SizedBox.shrink(),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    '$_myScore pts',
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
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
                // Opponent progress placeholder
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person,
                          color: AppColors.textMuted, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        opponentName,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 13),
                      ),
                      const Spacer(),
                      const Text(
                        '⚔️ En jeu',
                        style: TextStyle(
                            color: AppColors.accent, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_questionIndex + 1) /
                        duel.questionIds.length,
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary),
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    TimerWidget(
                      seconds: quiz.timerSeconds,
                      maxSeconds: AppConstants.duelTimerSeconds,
                    ),
                    const Spacer(),
                    Text(
                      '${_questionIndex + 1} / ${duel.questionIds.length}',
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (quiz.currentQuestion != null) ...[
                  QuestionCard(
                    question: quiz.currentQuestion!,
                    questionNumber: _questionIndex + 1,
                    total: duel.questionIds.length,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount:
                          quiz.currentQuestion!.choices.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final choice =
                            quiz.currentQuestion!.choices[i];
                        AnswerState state = AnswerState.idle;
                        if (_answered) {
                          if (choice ==
                              quiz.currentQuestion!.correctAnswer) {
                            state = AnswerState.correct;
                          } else if (choice == _selectedAnswer) {
                            state = AnswerState.wrong;
                          }
                        }
                        return AnswerButton(
                          text: choice,
                          state: state,
                          index: i,
                          onPressed: () => _answer(choice,
                              quiz.currentQuestion!.correctAnswer),
                        );
                      },
                    ),
                  ),
                ] else
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Erreur: $e')),
      ),
    );
  }
}
