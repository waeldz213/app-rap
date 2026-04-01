import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../providers/user_provider.dart';
import '../../providers/pack_provider.dart';
import '../../config/theme.dart';
import '../../widgets/daily_challenge_banner.dart';
import '../../widgets/pack_card.dart';
import '../../widgets/stat_tile.dart';
import '../../widgets/coin_display.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDataProvider);
    final packsAsync = ref.watch(packsProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: AppTheme.background,
              elevation: 0,
              title: userAsync.when(
                data: (user) => Text(
                  'Salut ${user?.username ?? 'Rappeur'} 👋',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const Text('App Rap'),
              ),
              actions: [
                userAsync.when(
                  data: (user) => Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: CoinDisplay(amount: user?.coins ?? 0),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const DailyChallengeBanner(),
                  const SizedBox(height: 24),
                  // Stats section
                  userAsync.when(
                    data: (user) {
                      if (user == null) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mes stats',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: StatTile(
                                  icon: Icons.local_fire_department,
                                  value: '${user.streak}',
                                  label: 'Série',
                                  iconColor: AppTheme.accent,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: StatTile(
                                  icon: Icons.emoji_events,
                                  value: user.rankTier,
                                  label: 'Rang',
                                  iconColor: AppTheme.gold,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: StatTile(
                                  icon: Icons.star,
                                  value: '${user.xp}',
                                  label: 'XP',
                                  iconColor: AppTheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ).animate().fadeIn(duration: 400.ms);
                    },
                    loading: () => const SizedBox(height: 100),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 24),
                  // Packs section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Packs récents',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/packs'),
                        child: const Text(
                          'Voir tout',
                          style: TextStyle(color: AppTheme.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  packsAsync.when(
                    data: (packs) {
                      if (packs.isEmpty) {
                        return const Center(
                          child: Text(
                            'Aucun pack disponible',
                            style: TextStyle(color: AppTheme.textSecondary),
                          ),
                        );
                      }
                      return SizedBox(
                        height: 200,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: packs.take(6).length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) => PackCard(
                            pack: packs[index],
                            compact: true,
                          ),
                        ),
                      );
                    },
                    loading: () => const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 80),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
