import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../providers/collection_provider.dart';
import '../../models/card_model.dart';
import '../../config/theme.dart';
import '../../widgets/rarity_badge.dart';

class CollectionScreen extends ConsumerStatefulWidget {
  const CollectionScreen({super.key});

  @override
  ConsumerState<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends ConsumerState<CollectionScreen> {
  CardRarity? _selectedRarity;

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(userCardsProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Ma Collection'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () => context.push('/collection/booster'),
            tooltip: 'Ouvrir un booster',
          ),
        ],
      ),
      body: Column(
        children: [
          // Rarity filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Tout',
                  isSelected: _selectedRarity == null,
                  onTap: () => setState(() => _selectedRarity = null),
                ),
                ...CardRarity.values.map((rarity) => _FilterChip(
                      label: rarity.displayName,
                      isSelected: _selectedRarity == rarity,
                      onTap: () => setState(() => _selectedRarity = rarity),
                    )),
              ],
            ),
          ),
          Expanded(
            child: cardsAsync.when(
              data: (cards) {
                final filtered = _selectedRarity == null
                    ? cards
                    : cards.where((c) => c.rarity == _selectedRarity).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🃏', style: TextStyle(fontSize: 64)),
                        const SizedBox(height: 16),
                        const Text(
                          'Aucune carte',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => context.push('/collection/booster'),
                          child: const Text(
                            'Ouvrir un booster',
                            style: TextStyle(color: AppTheme.primary),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => _CardTile(
                    card: filtered[index],
                    index: index,
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('Erreur: $e',
                    style: const TextStyle(color: AppTheme.error)),
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
  final int index;

  const _CardTile({required this.card, required this.index});

  Color get _glowColor {
    switch (card.rarity) {
      case CardRarity.legendary:
        return AppTheme.legendary;
      case CardRarity.epic:
        return AppTheme.epic;
      case CardRarity.rare:
        return AppTheme.rare;
      case CardRarity.commune:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/collection/${card.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (card.rarity != CardRarity.commune)
              BoxShadow(
                color: _glowColor.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
          ],
          border: Border.all(
            color: _glowColor.withOpacity(0.4),
            width: card.rarity == CardRarity.commune ? 0 : 1,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12)),
                child: card.imageUrl != null
                    ? Image.network(
                        card.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.person, color: AppTheme.textSecondary, size: 36),
                        ),
                      )
                    : Container(
                        decoration: const BoxDecoration(
                            gradient: AppTheme.premiumGradient),
                        child: const Center(
                          child: Icon(Icons.person, color: Colors.white54, size: 36),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                children: [
                  Text(
                    card.name,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  RarityBadge(rarity: card.rarity, small: true),
                ],
              ),
            ),
          ],
        ),
      )
          .animate(delay: (index * 40).ms)
          .fadeIn(duration: 300.ms)
          .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textSecondary,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
