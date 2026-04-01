import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/user_provider.dart';
import '../../providers/daily_challenge_provider.dart';
import '../../providers/pack_provider.dart';
import '../../widgets/coin_display.dart';
import '../../widgets/xp_bar.dart';
import '../../widgets/daily_challenge_banner.dart';
import '../../widgets/stat_tile.dart';
import '../../widgets/pack_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userModelProvider);
    final challengeAsync = ref.watch(dailyChallengeProvider);
    final packsAsync = ref.watch(packsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: userAsync.when(
          data: (user) => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Salut, ${user?.displayName ?? 'Rappeur'} 👋',
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Niveau ${user?.level ?? 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CoinDisplay(coins: user?.coins ?? 0),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => context.go('/settings'),
                            child: const Icon(
                              Icons.settings_outlined,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      XpBar(
                        currentXp: user?.xp ?? 0,
                        level: user?.level ?? 1,
                      ),
                      const SizedBox(height: 24),

                      // Daily challenge
                      const Text(
                        '🔥 Défi du jour',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      challengeAsync.when(
                        data: (challenge) => DailyChallengeBanner(
                          challenge: challenge,
                          onTap: challenge != null
                              ? () => context.go(
                                  '/quiz/${challenge.packId}')
                              : null,
                        ),
                        loading: () => const SizedBox(
                          height: 80,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 24),

                      // Quick stats
                      const Text(
                        '📊 Mes stats',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1.1,
                        children: [
                          StatTile(
                            icon: Icons.local_fire_department,
                            value: '${user?.stats.currentStreak ?? 0}',
                            label: 'Streak',
                            iconColor: AppColors.accent,
                          ),
                          StatTile(
                            icon: Icons.emoji_events,
                            value: '${user?.stats.duelWins ?? 0}',
                            label: 'Victoires',
                            iconColor: AppColors.legendaire,
                          ),
                          StatTile(
                            icon: Icons.style,
                            value: '${user?.stats.totalCards ?? 0}',
                            label: 'Cartes',
                            iconColor: AppColors.epique,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Featured packs
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '🎧 Packs populaires',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.go('/packs'),
                            child: const Text('Voir tout'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              packsAsync.when(
                data: (packs) => SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => PackCard(
                        pack: packs[index],
                        onTap: () =>
                            context.go('/packs/${packs[index].id}'),
                      ),
                      childCount: packs.take(4).length,
                    ),
                  ),
                ),
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) => const SliverToBoxAdapter(
                  child: SizedBox.shrink(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(
            child: Text(
              'Erreur de chargement',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
