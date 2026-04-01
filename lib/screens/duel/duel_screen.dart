import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/duel_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/duel_model.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
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
  bool _hasAnswered = false;
  int _remainingTime = AppConstants.questionTimeLimit;
  Timer? _nextTimer;

  void _onAnswer(String answer) {
    if (_hasAnswered) return;
    setState(() {
      _selectedAnswer = answer;
      _hasAnswered = true;
    });

    final authService = ref.read(authServiceProvider);
    final userId = authService.currentUser?.uid ?? '';
    final duelState = ref.read(duelNotifierProvider);
    final duel = duelState.duel;
    if (duel == null) return;

    ref.read(duelNotifierProvider.notifier).submitAnswer(
          duelId: widget.duelId,
          answer: answer,
          secondsUsed: AppConstants.questionTimeLimit - _remainingTime,
          isInitiator: duel.initiatorUserId == userId,
        );

    _nextTimer = Timer(const Duration(milliseconds: 1500), _goNext);
  }

  void _goNext() {
    setState(() {
      _selectedAnswer = null;
      _hasAnswered = false;
      _remainingTime = AppConstants.questionTimeLimit;
    });

    final duelState = ref.read(duelNotifierProvider);
    if (duelState.currentQuestionIndex >= duelState.questions.length - 1) {
      // Complete duel
      final authService = ref.read(authServiceProvider);
      final userId = authService.currentUser?.uid ?? '';
      final duel = duelState.duel;
      if (duel != null) {
        final isInitiator = duel.initiatorUserId == userId;
        final myScore = isInitiator ? duel.initiatorScore : duel.opponentScore;
        final theirScore =
            isInitiator ? duel.opponentScore : duel.initiatorScore;
        final winnerId = myScore >= theirScore ? userId : duel.opponentUserId;

        ref.read(duelServiceProvider).completeDuel(
              duelId: widget.duelId,
              winnerId: winnerId ?? userId,
              initiatorScore: duel.initiatorScore,
              opponentScore: duel.opponentScore,
            );
      }
      context.pushReplacement(
        '/duel/${widget.duelId}/result',
        extra: {
          'initiatorScore': duel?.initiatorScore ?? 0,
          'opponentScore': duel?.opponentScore ?? 0,
          'winnerId':
              duel?.initiatorUserId == userId ? userId : duel?.opponentUserId,
          'userId': userId,
        },
      );
    } else {
      ref.read(duelNotifierProvider.notifier).nextQuestion();
    }
  }

  AnswerState _getAnswerState(String option) {
    if (!_hasAnswered) return AnswerState.idle;
    final q = ref.read(duelNotifierProvider).currentQuestion;
    if (option == q?.correctAnswer) return AnswerState.correct;
    if (option == _selectedAnswer) return AnswerState.wrong;
    return AnswerState.idle;
  }

  @override
  void dispose() {
    _nextTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duelLive = ref.watch(activeDuelProvider(widget.duelId));
    final duelState = ref.watch(duelNotifierProvider);
    final authService = ref.watch(authServiceProvider);
    final userId = authService.currentUser?.uid ?? '';

    return duelLive.when(
      data: (duel) {
        // Load questions if not yet loaded
        if (duelState.questions.isEmpty && !duelState.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(duelNotifierProvider.notifier).loadQuestionsForDuel(duel);
          });
        }

        if (duel.status == DuelStatus.waiting) {
          return Scaffold(
            backgroundColor: AppTheme.background,
            appBar: AppBar(title: const Text('Duel')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('⏳', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  const Text(
                    'En attente de l\'adversaire...',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    'Code: ${widget.duelId}',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const CircularProgressIndicator(color: AppTheme.primary),
                ],
              ),
            ),
          );
        }

        final question = duelState.currentQuestion;
        final isInitiator = duel.initiatorUserId == userId;
        final myScore = isInitiator ? duel.initiatorScore : duel.opponentScore;
        final theirScore =
            isInitiator ? duel.opponentScore : duel.initiatorScore;

        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            title: const Text('Duel 1v1'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  'Q ${duelState.currentQuestionIndex + 1}/${duelState.questions.length}',
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Score display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ScoreBadge(label: 'Moi', score: myScore, isMe: true),
                      const Text('VS',
                          style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w700)),
                      _ScoreBadge(
                          label: 'Adversaire', score: theirScore, isMe: false),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (question != null) ...[
                    TimerWidget(
                      key: ValueKey(duelState.currentQuestionIndex),
                      durationSeconds: AppConstants.questionTimeLimit,
                      onTimeout: () => _onAnswer(''),
                      onTick: (s) => setState(() => _remainingTime = s),
                    ),
                    const SizedBox(height: 12),
                    QuestionCard(
                      key: ValueKey(question.id),
                      question: question,
                      questionNumber: duelState.currentQuestionIndex + 1,
                      totalQuestions: duelState.questions.length,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        itemCount: question.choices.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final option = question.choices[i];
                          return AnswerButton(
                            text: option,
                            state: _getAnswerState(option),
                            onTap: _hasAnswered ? null : () => _onAnswer(option),
                            index: i,
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
          ),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(),
        body: Center(
            child: Text('Erreur: $e',
                style: const TextStyle(color: AppTheme.error))),
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  final String label;
  final int score;
  final bool isMe;

  const _ScoreBadge({
    required this.label,
    required this.score,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: isMe ? AppTheme.premiumGradient : null,
        color: isMe ? null : AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isMe ? Colors.white : AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
          Text(
            '$score',
            style: TextStyle(
              color: isMe ? Colors.white : AppTheme.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
