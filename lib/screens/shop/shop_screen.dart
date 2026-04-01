import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/glass_card.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Boutique')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Premium card
            GlassCard(
              showGradientBorder: true,
              borderGradient: AppTheme.goldGradient,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text('👑', style: TextStyle(fontSize: 32)),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Premium',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Accès illimité à tous les packs',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...[
                    '✅ Tous les packs débloqués',
                    '✅ Boosters bonus chaque semaine',
                    '✅ Badge Premium exclusif',
                    '✅ Pas de publicités',
                  ].map((feature) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Text(
                              feature,
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 20),
                  GradientButton(
                    gradient: AppTheme.goldGradient,
                    onPressed: () => context.push('/shop/subscription'),
                    text: 'Voir les offres',
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 28),
            const Text(
              'Pièces',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 12),
            ..._coinPackages.asMap().entries.map((entry) {
              final i = entry.key;
              final pkg = entry.value;
              return _CoinPackageCard(package: pkg)
                  .animate(delay: (250 + i * 80).ms)
                  .fadeIn()
                  .slideY(begin: 0.1);
            }),
            const SizedBox(height: 28),
            const Text(
              'Boosters',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 12),
            _BoosterCard()
                .animate(delay: 450.ms)
                .fadeIn()
                .slideY(begin: 0.1),
          ],
        ),
      ),
    );
  }

  static const _coinPackages = [
    _CoinPackage(coins: 100, price: '0.99€', emoji: '🪙'),
    _CoinPackage(coins: 500, price: '3.99€', emoji: '💰', isBestValue: false),
    _CoinPackage(coins: 1200, price: '7.99€', emoji: '💎', isBestValue: true),
  ];
}

class _CoinPackage {
  final int coins;
  final String price;
  final String emoji;
  final bool isBestValue;

  const _CoinPackage({
    required this.coins,
    required this.price,
    required this.emoji,
    this.isBestValue = false,
  });
}

class _CoinPackageCard extends StatelessWidget {
  final _CoinPackage package;

  const _CoinPackageCard({required this.package});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: package.isBestValue
            ? Border.all(color: AppTheme.accent.withOpacity(0.5))
            : null,
      ),
      child: Row(
        children: [
          Text(package.emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${package.coins} Pièces',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (package.isBestValue)
                  const Text(
                    '🔥 Meilleure offre',
                    style: TextStyle(color: AppTheme.accent, fontSize: 12),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Achat bientôt disponible')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text(
              package.price,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _BoosterCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.premiumGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text('📦', style: TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booster Pack',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '3 cartes aléatoires',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => context.push('/collection/booster'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('200 🪙',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
