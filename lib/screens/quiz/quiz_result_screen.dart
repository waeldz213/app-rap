import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/animated_counter.dart';

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final int xpGained;
  final int coinsGained;
  final String packId;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.xpGained,
    required this.coinsGained,
    required this.packId,
  });

  String get _emoji {
    final ratio = score / (total * 150);
    if (ratio >= 0.8) return '🏆';
    if (ratio >= 0.5) return '⭐';
    return '💪';
  }

  String get _message {
    final ratio = score / (total * 150);
    if (ratio >= 0.8) return 'Incroyable ! Tu connais ton rap !';
    if (ratio >= 0.5) return 'Pas mal du tout !';
    return 'Continue à t\'entraîner !';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _emoji,
                style: const TextStyle(fontSize: 80),
              )
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.elasticOut),
              const SizedBox(height: 24),
              Text(
                _message,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedCounter(
                          value: score,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Text(
                          ' pts',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _RewardItem(
                          emoji: '✅',
                          value: total.toString(),
                          label: 'Questions',
                        ),
                        _RewardItem(
                          emoji: '🪙',
                          value: '+$coinsGained',
                          label: 'Coins',
                          color: AppColors.accent,
                        ),
                        _RewardItem(
                          emoji: '⭐',
                          value: '+$xpGained',
                          label: 'XP',
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 40),
              GradientButton(
                text: 'Rejouer',
                onPressed: () => context.go('/quiz/$packId'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Retour à l\'accueil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RewardItem extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color? color;

  const _RewardItem({
    required this.emoji,
    required this.value,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color ?? AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
      ],
    );
  }
}
