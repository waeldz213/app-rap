import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/collection_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/card_model.dart';
import '../../config/theme.dart';
import '../../widgets/rarity_badge.dart';
import '../../widgets/gradient_button.dart';

class CardDetailScreen extends ConsumerWidget {
  final String cardId;

  const CardDetailScreen({super.key, required this.cardId});

  Color _glowColor(CardRarity rarity) {
    switch (rarity) {
      case CardRarity.legendary:
        return AppTheme.legendary;
      case CardRarity.epic:
        return AppTheme.epic;
      case CardRarity.rare:
        return AppTheme.rare;
      case CardRarity.commune:
        return AppTheme.textSecondary;
    }
  }

  Gradient _cardGradient(CardRarity rarity) {
    switch (rarity) {
      case CardRarity.legendary:
        return AppTheme.goldGradient;
      case CardRarity.epic:
        return AppTheme.premiumGradient;
      case CardRarity.rare:
        return const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)]);
      case CardRarity.commune:
        return const LinearGradient(
            colors: [Color(0xFF6B7280), Color(0xFF374151)]);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardAsync = ref.watch(cardDetailProvider(cardId));
    final authService = ref.watch(authServiceProvider);

    return cardAsync.when(
      data: (card) {
        if (card == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
                child: Text('Carte introuvable',
                    style: TextStyle(color: AppTheme.textSecondary))),
          );
        }

        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(title: Text(card.name)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Card display with glow
                Center(
                  child: Container(
                    width: 220,
                    height: 320,
                    decoration: BoxDecoration(
                      gradient: _cardGradient(card.rarity),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _glowColor(card.rarity).withOpacity(0.6),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (card.imageUrl != null)
                            Image.network(
                              card.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Center(
                                child: Icon(Icons.person,
                                    color: Colors.white54, size: 80),
                              ),
                            )
                          else
                            const Center(
                              child: Icon(Icons.person,
                                  color: Colors.white54, size: 80),
                            ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Colors.black87, Colors.transparent],
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    card.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  RarityBadge(rarity: card.rarity),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .scale(begin: const Offset(0.8, 0.8)),
                ),
                const SizedBox(height: 32),
                // Info section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoRow(label: 'Artiste', value: card.artist),
                      if (card.era != null)
                        _InfoRow(label: 'Ère', value: card.era!),
                      if (card.bonusType != null)
                        _InfoRow(
                          label: 'Bonus',
                          value:
                              '${card.bonusType}: +${((card.bonusValue ?? 0) * 100).round()}%',
                        ),
                      const SizedBox(height: 12),
                      Text(
                        card.description,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 24),
                GradientButton(
                  gradient: _cardGradient(card.rarity),
                  onPressed: () async {
                    final userId = authService.currentUser?.uid;
                    if (userId == null) return;
                    await ref
                        .read(collectionServiceProvider)
                        .equipCard(userId, cardId);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Carte équipée! +10% de bonus'),
                          backgroundColor: AppTheme.success,
                        ),
                      );
                    }
                  },
                  text: '⚡ Équiper cette carte',
                ).animate().fadeIn(delay: 300.ms),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
          appBar: AppBar(),
          body: Center(child: Text('Erreur: $e'))),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
