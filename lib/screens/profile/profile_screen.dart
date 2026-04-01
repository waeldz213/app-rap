import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/user_provider.dart';
import '../../providers/collection_provider.dart';
import '../../widgets/xp_bar.dart';
import '../../widgets/stat_tile.dart';
import '../../widgets/rarity_badge.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userModelProvider);
    final cardsAsync = ref.watch(userCardsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(
                child: Text('Utilisateur introuvable'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Avatar + name
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor:
                            Colors.white.withOpacity(0.2),
                        child: Text(
                          user.displayName.isNotEmpty
                              ? user.displayName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (user.isPremium)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '👑 Premium',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      XpBar(currentXp: user.xp, level: user.level),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Stats
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '📊 Statistiques',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    StatTile(
                      icon: Icons.quiz_outlined,
                      value: '${user.stats.totalQuizzes}',
                      label: 'Quiz joués',
                    ),
                    StatTile(
                      icon: Icons.check_circle_outline,
                      value:
                          '${(user.stats.accuracy * 100).toInt()}%',
                      label: 'Précision',
                      iconColor: AppColors.success,
                    ),
                    StatTile(
                      icon: Icons.emoji_events_outlined,
                      value: '${user.stats.duelWins}',
                      label: 'Victoires',
                      iconColor: AppColors.legendaire,
                    ),
                    StatTile(
                      icon: Icons.local_fire_department,
                      value: '${user.stats.maxStreak}',
                      label: 'Meilleur streak',
                      iconColor: AppColors.accent,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Equipped cards
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '🃏 Cartes équipées',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                cardsAsync.when(
                  data: (cards) {
                    if (cards.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Aucune carte. Ouvre des boosters !',
                          style: TextStyle(
                              color: AppColors.textSecondary),
                        ),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount:
                          cards.take(3).length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final card = cards[i];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Text('🎤',
                                  style: TextStyle(fontSize: 24)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      card.artistName,
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      card.title,
                                      style: const TextStyle(
                                          color:
                                              AppColors.textMuted,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              RarityBadge(
                                  rarity: card.rarity, small: true),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const CircularProgressIndicator(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(
            child: Text('Erreur')),
      ),
    );
  }
}
