import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../widgets/gradient_button.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Boutique')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Premium banner
            GestureDetector(
              onTap: () => context.go('/shop/subscription'),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '👑 Premium',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Accès illimité à tous les packs',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 13),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'À partir de 4,99 €/mois',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text('👑', style: TextStyle(fontSize: 48)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Packs individuels',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Achète un pack spécifique sans abonnement',
              style:
                  TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 16),
            _PackShopItem(
              emoji: '👑',
              title: 'Légendes 90s/2000s',
              price: '2,99 €',
              gradientColors: [const Color(0xFFF59E0B), const Color(0xFFF97316)],
            ),
            const SizedBox(height: 12),
            _PackShopItem(
              emoji: '🔥',
              title: 'Nouvelle École',
              price: '2,99 €',
              gradientColors: [const Color(0xFFEF4444), const Color(0xFFF97316)],
            ),
            const SizedBox(height: 12),
            _PackShopItem(
              emoji: '✨',
              title: 'Plume & Mélodie',
              price: '2,99 €',
              gradientColors: [const Color(0xFF3B82F6), const Color(0xFF7C3AED)],
            ),
            const SizedBox(height: 12),
            _PackShopItem(
              emoji: '🌙',
              title: 'Spécial PNL',
              price: '2,99 €',
              gradientColors: [const Color(0xFF1a1a2e), const Color(0xFF7C3AED)],
            ),
            const SizedBox(height: 24),
            const Text(
              'Coins',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            _CoinPackItem(coins: 200, price: '0,99 €', bonus: null),
            const SizedBox(height: 8),
            _CoinPackItem(coins: 600, price: '2,49 €', bonus: '+100 bonus'),
            const SizedBox(height: 8),
            _CoinPackItem(coins: 1500, price: '4,99 €', bonus: '+500 bonus'),
          ],
        ),
      ),
    );
  }
}

class _PackShopItem extends StatelessWidget {
  final String emoji;
  final String title;
  final String price;
  final List<Color> gradientColors;

  const _PackShopItem({
    required this.emoji,
    required this.title,
    required this.price,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              price,
              style: const TextStyle(
                  color: AppColors.accent, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoinPackItem extends StatelessWidget {
  final int coins;
  final String price;
  final String? bonus;

  const _CoinPackItem({
    required this.coins,
    required this.price,
    this.bonus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Row(
        children: [
          const Text('🪙', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$coins coins',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (bonus != null)
                  Text(
                    bonus!,
                    style: const TextStyle(
                        color: AppColors.success, fontSize: 12),
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              price,
              style: const TextStyle(
                  color: AppColors.accent, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
