import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/animated_counter.dart';

class QuizResultScreen extends ConsumerWidget {
  final String packId;
  final Map<String, dynamic>? extra;

  const QuizResultScreen({
    super.key,
    required this.packId,
    this.extra,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = (extra?['score'] as int?) ?? 0;
    final correctAnswers = (extra?['correctAnswers'] as int?) ?? 0;
    final totalQuestions = (extra?['totalQuestions'] as int?) ?? 1;
    final coinsEarned = score ~/ 10;
    final xpEarned = score ~/ 20;
    final percentage = (correctAnswers / totalQuestions * 100).round();

    String _getEmoji() {
      if (percentage >= 90) return '🏆';
      if (percentage >= 70) return '🎉';
      if (percentage >= 50) return '👍';
      return '💪';
    }

    String _getMessage() {
      if (percentage >= 90) return 'Légendaire!';
      if (percentage >= 70) return 'Excellent!';
      if (percentage >= 50) return 'Pas mal!';
      return 'Continue à t\'entraîner!';
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Text(
                _getEmoji(),
                style: const TextStyle(fontSize: 80),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0, 0),
                    end: const Offset(1, 1),
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  ),
              const SizedBox(height: 16),
              Text(
                _getMessage(),
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 32),
              // Score card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppTheme.premiumGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Score Final',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    AnimatedCounter(
                      value: score,
                      duration: const Duration(milliseconds: 1200),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'points',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 24),
              // Stats row
              Row(
                children: [
                  Expanded(
                    child: _ResultStat(
                      emoji: '✅',
                      value: '$correctAnswers/$totalQuestions',
                      label: 'Correctes',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ResultStat(
                      emoji: '🪙',
                      value: '+$coinsEarned',
                      label: 'Pièces',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ResultStat(
                      emoji: '⭐',
                      value: '+$xpEarned',
                      label: 'XP',
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 400.ms),
              const Spacer(),
              GradientButton(
                gradient: AppTheme.premiumGradient,
                onPressed: () => context.push('/quiz/$packId'),
                text: '🔄 Rejouer',
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => context.go('/home'),
                  child: const Text(
                    'Retour à l\'accueil',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ),
              ).animate().fadeIn(delay: 550.ms),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;

  const _ResultStat({
    required this.emoji,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
