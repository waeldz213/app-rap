import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/collection_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/rarity_badge.dart';
import '../../widgets/gradient_button.dart';
import '../../models/card_model.dart';

class CollectionScreen extends ConsumerWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardsAsync = ref.watch(userCardsProvider);
    final userAsync = ref.watch(userModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ma Collection'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: () => context.go('/collection/booster'),
              icon: const Text('🎁'),
              label: const Text(
                'Booster',
                style: TextStyle(color: AppColors.accent),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // User coins & booster CTA
          userAsync.when(
            data: (user) => Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Text('🪙', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    '${user?.coins ?? 0} coins',
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: (user?.coins ?? 0) >= 100
                        ? () => context.go('/collection/booster')
                        : null,
                    child: const Text('Ouvrir booster (100🪙)'),
                  ),
                ],
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          Expanded(
            child: cardsAsync.when(
              data: (cards) {
                if (cards.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🃏', style: TextStyle(fontSize: 48)),
                        SizedBox(height: 16),
                        Text(
                          'Aucune carte pour l\'instant',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Ouvre des boosters pour collectionner !',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: cards.length,
                  itemBuilder: (context, index) =>
                      _CardTile(card: cards[index]),
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('Erreur: $e',
                    style:
                        const TextStyle(color: AppColors.textSecondary)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardTile extends StatelessWidget {
  final CardModel card;

  const _CardTile({required this.card});

  Color get _rarityColor {
    switch (card.rarity) {
      case CardRarity.commune:
        return AppColors.commune;
      case CardRarity.rare:
        return AppColors.rare;
      case CardRarity.epique:
        return AppColors.epique;
      case CardRarity.legendaire:
        return AppColors.legendaire;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/collection/${card.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _rarityColor.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: _rarityColor.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _rarityColor.withOpacity(0.3),
                      _rarityColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🎤', style: TextStyle(fontSize: 36)),
                    const SizedBox(height: 8),
                    Text(
                      card.artistName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.title,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  RarityBadge(rarity: card.rarity, small: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
