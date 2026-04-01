import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../providers/pack_provider.dart';
import '../../config/theme.dart';
import '../../widgets/gradient_button.dart';

class PackDetailScreen extends ConsumerWidget {
  final String packId;

  const PackDetailScreen({super.key, required this.packId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packAsync = ref.watch(packDetailProvider(packId));

    return packAsync.when(
      data: (pack) {
        if (pack == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text('Pack introuvable',
                  style: TextStyle(color: AppTheme.textSecondary)),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: pack.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: pack.imageUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => _PlaceholderHeader(),
                        )
                      : _PlaceholderHeader(),
                  title: Text(
                    pack.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      shadows: [Shadow(color: Colors.black, blurRadius: 8)],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Category & Era
                    Wrap(
                      spacing: 8,
                      children: [
                        _Chip(label: pack.category, icon: Icons.category),
                        if (pack.era != null)
                          _Chip(label: pack.era!, icon: Icons.calendar_today),
                        if (pack.artist != null)
                          _Chip(label: pack.artist!, icon: Icons.mic),
                      ],
                    ).animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: 16),
                    Text(
                      pack.description,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 20),
                    // Stats row
                    Row(
                      children: [
                        _StatChip(
                          icon: Icons.quiz,
                          value: '${pack.questionCount}',
                          label: 'Questions',
                        ),
                        const SizedBox(width: 12),
                        _StatChip(
                          icon: Icons.play_circle,
                          value: '${pack.totalPlays}',
                          label: 'Parties',
                        ),
                        const SizedBox(width: 12),
                        _StatChip(
                          icon: Icons.speed,
                          value: '${'★' * pack.difficulty}',
                          label: 'Difficulté',
                        ),
                      ],
                    ).animate().fadeIn(delay: 150.ms),
                    // Grind requirement
                    if (pack.grindRequirement != null) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.accent.withOpacity(0.1),
                          border: Border.all(
                              color: AppTheme.accent.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.lock_open, color: AppTheme.accent, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Conditions pour débloquer',
                                  style: TextStyle(
                                    color: AppTheme.accent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '• ${pack.grindRequirement!.duelWinsRequired} victoires en duel',
                              style: const TextStyle(
                                  color: AppTheme.textSecondary, fontSize: 13),
                            ),
                            Text(
                              '• ${pack.grindRequirement!.soloCorrectRequired} bonnes réponses en solo',
                              style: const TextStyle(
                                  color: AppTheme.textSecondary, fontSize: 13),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 200.ms),
                    ],
                    const SizedBox(height: 32),
                    GradientButton(
                      gradient: AppTheme.premiumGradient,
                      onPressed: () => context.push('/quiz/$packId'),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Jouer Solo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 250.ms),
                    const SizedBox(height: 12),
                    GradientButton(
                      gradient: AppTheme.fireGradient,
                      onPressed: () => context.push('/duel/lobby'),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sports_esports, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Duel 1v1',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 300.ms),
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Erreur: $e')),
      ),
    );
  }
}

class _PlaceholderHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.premiumGradient),
      child: const Center(
        child: Icon(Icons.music_note, color: Colors.white54, size: 80),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _Chip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primary, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
