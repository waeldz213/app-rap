import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/theme.dart';
import '../models/daily_challenge_model.dart';

class DailyChallengeBanner extends StatelessWidget {
  final DailyChallengeModel? challenge;
  final VoidCallback? onTap;

  const DailyChallengeBanner({super.key, this.challenge, this.onTap});

  String _timeRemaining() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final diff = tomorrow.difference(now);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    return '${hours}h ${minutes}min restantes';
  }

  @override
  Widget build(BuildContext context) {
    if (challenge == null) return const SizedBox.shrink();

    final isCompleted = challenge!.isCompleted == true;

    return GestureDetector(
      onTap: isCompleted ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isCompleted
              ? const LinearGradient(
                  colors: [AppColors.surfaceVariant, AppColors.surface])
              : const LinearGradient(
                  colors: [Color(0xFF1a1a3e), AppColors.surfaceVariant]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompleted
                ? AppColors.success.withOpacity(0.3)
                : AppColors.accent.withOpacity(0.4),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.success.withOpacity(0.15)
                    : AppColors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isCompleted ? '✅' : '🔥',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCompleted
                        ? 'Défi du jour complété !'
                        : 'Défi du jour',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isCompleted
                        ? 'Reviens demain pour un nouveau défi'
                        : '${challenge!.packTitle} • ${challenge!.questionIds.length} questions',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  if (!isCompleted) ...[
                    const SizedBox(height: 4),
                    Text(
                      _timeRemaining(),
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (!isCompleted) ...[
              const SizedBox(width: 8),
              Column(
                children: [
                  Text(
                    '+${challenge!.bonusCoins}🪙',
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '+${challenge!.bonusXp}XP',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
              ),
            ],
          ],
        ),
      )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .shimmer(
            duration: 3.seconds,
            color: isCompleted
                ? AppColors.success.withOpacity(0.05)
                : AppColors.accent.withOpacity(0.05),
          ),
    );
  }
}
