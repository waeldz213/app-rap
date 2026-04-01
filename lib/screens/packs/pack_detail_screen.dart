import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/pack_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/gradient_button.dart';

class PackDetailScreen extends ConsumerWidget {
  final String packId;

  const PackDetailScreen({super.key, required this.packId});

  Color _colorFromHex(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packAsync = ref.watch(packDetailProvider(packId));
    final userAsync = ref.watch(userModelProvider);

    return packAsync.when(
      data: (pack) {
        if (pack == null) {
          return const Scaffold(
            body: Center(child: Text('Pack introuvable')),
          );
        }
        final isPremium = userAsync.valueOrNull?.isPremium ?? false;
        final hasAccess = pack.isFree || isPremium;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                backgroundColor: AppColors.background,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _colorFromHex(pack.gradientStart),
                          _colorFromHex(pack.gradientEnd),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        pack.iconEmoji,
                        style: const TextStyle(fontSize: 80),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pack.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pack.subtitle,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        pack.description,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (!hasAccess) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppColors.accent.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Text('👑', style: TextStyle(fontSize: 24)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Pack Premium',
                                      style: TextStyle(
                                        color: AppColors.accent,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      'Abonne-toi pour accéder à ce pack',
                                      style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        GradientButton(
                          text: 'Débloquer avec Premium',
                          gradient: AppColors.accentGradient,
                          onPressed: () =>
                              context.go('/shop/subscription'),
                          icon: Icons.workspace_premium,
                        ),
                      ] else ...[
                        const Text(
                          'Choisir ton mode',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GradientButton(
                          text: '🎤 Solo - Quiz',
                          onPressed: () =>
                              context.go('/quiz/$packId'),
                        ),
                        const SizedBox(height: 12),
                        GradientButton(
                          text: '⚔️ Duel 1v1',
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFEF4444),
                              Color(0xFFF97316)
                            ],
                          ),
                          onPressed: () =>
                              context.go('/duel/lobby'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Erreur: $e')),
      ),
    );
  }
}
