import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/animated_counter.dart';

class DuelResultScreen extends ConsumerWidget {
  final String duelId;
  final Map<String, dynamic>? extra;

  const DuelResultScreen({
    super.key,
    required this.duelId,
    this.extra,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = extra?['userId'] as String? ?? '';
    final initiatorScore = (extra?['initiatorScore'] as int?) ?? 0;
    final opponentScore = (extra?['opponentScore'] as int?) ?? 0;
    final winnerId = extra?['winnerId'] as String?;
    final isWinner = winnerId == userId;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              // Win/Lose animation
              Text(
                isWinner ? '🏆' : '💀',
                style: const TextStyle(fontSize: 96),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0, 0),
                    end: const Offset(1, 1),
                    duration: 700.ms,
                    curve: Curves.elasticOut,
                  ),
              const SizedBox(height: 16),
              Text(
                isWinner ? 'VICTOIRE!' : 'DÉFAITE',
                style: TextStyle(
                  color: isWinner ? AppTheme.success : AppTheme.error,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 40),
              // Score comparison
              Row(
                children: [
                  Expanded(
                    child: _ScoreCard(
                      label: 'Moi',
                      score: initiatorScore,
                      isHigher: initiatorScore >= opponentScore,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'VS',
                      style: TextStyle(
                        color: AppTheme.textSecondary.withOpacity(0.6),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _ScoreCard(
                      label: 'Adversaire',
                      score: opponentScore,
                      isHigher: opponentScore > initiatorScore,
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 24),
              // Rank change
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isWinner
                      ? AppTheme.success.withOpacity(0.1)
                      : AppTheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isWinner
                        ? AppTheme.success.withOpacity(0.3)
                        : AppTheme.error.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isWinner ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isWinner ? AppTheme.success : AppTheme.error,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isWinner ? '+30 points de rang' : '-15 points de rang',
                      style: TextStyle(
                        color: isWinner ? AppTheme.success : AppTheme.error,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isWinner ? '+50 🪙' : '+10 🪙',
                      style: const TextStyle(
                        color: AppTheme.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 500.ms),
              const Spacer(),
              GradientButton(
                gradient: AppTheme.fireGradient,
                onPressed: () => context.go('/duel/lobby'),
                text: '⚔️ Revanche',
              ).animate().fadeIn(delay: 600.ms),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/home'),
                child: const Text(
                  'Retour à l\'accueil',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ).animate().fadeIn(delay: 650.ms),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final String label;
  final int score;
  final bool isHigher;

  const _ScoreCard({
    required this.label,
    required this.score,
    required this.isHigher,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isHigher ? AppTheme.premiumGradient : null,
        color: isHigher ? null : AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isHigher ? Colors.white : AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedCounter(
            value: score,
            duration: const Duration(milliseconds: 1000),
            style: TextStyle(
              color: isHigher ? Colors.white : AppTheme.textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            'pts',
            style: TextStyle(
              color: isHigher ? Colors.white70 : AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
