import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../providers/daily_challenge_provider.dart';
import '../config/theme.dart';

class DailyChallengeBanner extends ConsumerWidget {
  const DailyChallengeBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengeAsync = ref.watch(todayChallengeProvider);
    final hasCompletedAsync = ref.watch(hasCompletedTodayProvider);

    return challengeAsync.when(
      data: (challenge) {
        if (challenge == null) {
          return _BannerSkeleton();
        }

        final hasCompleted = hasCompletedAsync.valueOrNull ?? false;

        return GestureDetector(
          onTap: hasCompleted
              ? null
              : () => context.push('/quiz/${challenge.questionIds.first}'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: hasCompleted
                  ? const LinearGradient(
                      colors: [Color(0xFF374151), Color(0xFF1F2937)],
                    )
                  : AppTheme.fireGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(
                  hasCompleted ? '✅' : '🔥',
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasCompleted
                            ? 'Défi du jour complété!'
                            : 'Défi du jour disponible!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hasCompleted
                            ? 'Revenez demain pour un nouveau défi'
                            : '${challenge.coins} 🪙 + ${challenge.xp} XP à gagner',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!hasCompleted)
                  const Icon(Icons.arrow_forward_ios,
                      color: Colors.white, size: 16),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideX(begin: -0.05, end: 0),
        );
      },
      loading: () => _BannerSkeleton(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _BannerSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
    ).animate().shimmer(duration: 1500.ms);
  }
}
