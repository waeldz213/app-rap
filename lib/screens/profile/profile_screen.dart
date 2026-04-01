import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../providers/user_provider.dart';
import '../../providers/collection_provider.dart';
import '../../config/theme.dart';
import '../../widgets/xp_bar.dart';
import '../../widgets/stat_tile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  String _getRankEmoji(String rankTier) {
    switch (rankTier.toLowerCase()) {
      case 'bronze':
        return '🥉';
      case 'silver':
        return '🥈';
      case 'gold':
        return '🥇';
      case 'platinum':
        return '💎';
      case 'diamond':
        return '💠';
      case 'master':
        return '👑';
      default:
        return '🎤';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDataProvider);
    final cardsAsync = ref.watch(userCardsProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text('Utilisateur non trouvé',
                  style: TextStyle(color: AppTheme.textSecondary)),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Avatar & username
                Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppTheme.premiumGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          user.username.isNotEmpty
                              ? user.username[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
                    const SizedBox(height: 12),
                    Text(
                      user.username,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: user.isPremium
                            ? AppTheme.goldGradient
                            : null,
                        color: user.isPremium ? null : AppTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_getRankEmoji(user.rankTier)} ${user.rankTier} • ${user.rankPoints} pts',
                        style: TextStyle(
                          color: user.isPremium
                              ? Colors.white
                              : AppTheme.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ).animate().fadeIn(delay: 150.ms),
                  ],
                ),
                const SizedBox(height: 24),
                // XP Bar
                XPBar(xp: user.xp, level: user.level)
                    .animate()
                    .fadeIn(delay: 200.ms),
                const SizedBox(height: 24),
                // Stats grid
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.95,
                  children: [
                    StatTile(
                      icon: Icons.games,
                      value: '${user.stats.totalGamesPlayed}',
                      label: 'Parties',
                      iconColor: AppTheme.primary,
                    ),
                    StatTile(
                      icon: Icons.check_circle,
                      value: '${user.stats.totalCorrectAnswers}',
                      label: 'Bonnes rép.',
                      iconColor: AppTheme.success,
                    ),
                    StatTile(
                      icon: Icons.local_fire_department,
                      value: '${user.streak}',
                      label: 'Série',
                      iconColor: AppTheme.accent,
                    ),
                    StatTile(
                      icon: Icons.sports_esports,
                      value: '${user.stats.totalDuelsPlayed}',
                      label: 'Duels',
                      iconColor: AppTheme.secondary,
                    ),
                    StatTile(
                      icon: Icons.emoji_events,
                      value: '${user.stats.totalDuelWins}',
                      label: 'Victoires',
                      iconColor: AppTheme.gold,
                    ),
                    StatTile(
                      icon: Icons.monetization_on,
                      value: '${user.coins}',
                      label: 'Pièces',
                      iconColor: AppTheme.accent,
                    ),
                  ],
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: 24),
                // Equipped card
                if (user.equippedCardId != null) ...[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Carte équipée',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ref.watch(cardDetailProvider(user.equippedCardId!)).when(
                        data: (card) {
                          if (card == null) return const SizedBox.shrink();
                          return GestureDetector(
                            onTap: () => context
                                .push('/collection/${card.id}'),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: AppTheme.primary.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.flash_on,
                                      color: AppTheme.accent, size: 24),
                                  const SizedBox(width: 12),
                                  Text(
                                    card.name,
                                    style: const TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Text('+10% bonus',
                                      style: TextStyle(
                                        color: AppTheme.success,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ],
                              ),
                            ),
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                  const SizedBox(height: 8),
                ],
                // Cards count
                cardsAsync.when(
                  data: (cards) => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '🃏 Ma collection',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${cards.length} cartes',
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Erreur: $e',
              style: const TextStyle(color: AppTheme.error)),
        ),
      ),
    );
  }
}
