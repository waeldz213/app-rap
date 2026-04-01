import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/animated_counter.dart';

class DuelResultScreen extends ConsumerWidget {
  final String duelId;
  final int myScore;
  final int opponentScore;
  final String winnerId;

  const DuelResultScreen({
    super.key,
    required this.duelId,
    required this.myScore,
    required this.opponentScore,
    required this.winnerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserProvider)?.uid ?? '';
    final iWon = winnerId == userId;
    final isDraw = myScore == opponentScore;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isDraw ? '🤝' : (iWon ? '🏆' : '😤'),
                style: const TextStyle(fontSize: 80),
              ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
              const SizedBox(height: 16),
              Text(
                isDraw
                    ? 'Égalité !'
                    : (iWon ? 'Victoire !' : 'Défaite...'),
                style: TextStyle(
                  color: iWon ? AppColors.accent : AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ScoreColumn(
                      label: 'Toi',
                      score: myScore,
                      isWinner: iWon || isDraw,
                    ),
                    const Text(
                      'VS',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    _ScoreColumn(
                      label: 'Adversaire',
                      score: opponentScore,
                      isWinner: !iWon || isDraw,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          iWon ? '+50🪙' : '+10🪙',
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'Coins',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          iWon ? '+100 XP' : '+30 XP',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'Expérience',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              GradientButton(
                text: 'Revanche !',
                gradient: const LinearGradient(
                  colors: [Color(0xFFEF4444), Color(0xFFF97316)],
                ),
                onPressed: () => context.go('/duel/lobby'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/home'),
                child: const Text("Retour à l'accueil"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreColumn extends StatelessWidget {
  final String label;
  final int score;
  final bool isWinner;

  const _ScoreColumn({
    required this.label,
    required this.score,
    required this.isWinner,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
              color: AppColors.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 8),
        AnimatedCounter(
          value: score,
          style: TextStyle(
            color: isWinner ? AppColors.accent : AppColors.textPrimary,
            fontSize: 36,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          'points',
          style: const TextStyle(
              color: AppColors.textMuted, fontSize: 12),
        ),
      ],
    );
  }
}
