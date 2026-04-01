import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../models/card_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/collection_provider.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/rarity_badge.dart';

class BoosterOpeningScreen extends ConsumerStatefulWidget {
  const BoosterOpeningScreen({super.key});

  @override
  ConsumerState<BoosterOpeningScreen> createState() =>
      _BoosterOpeningScreenState();
}

class _BoosterOpeningScreenState
    extends ConsumerState<BoosterOpeningScreen> {
  List<CardModel> _cards = [];
  int _revealedCount = 0;
  bool _isOpening = false;
  bool _isFinished = false;

  Future<void> _openBooster() async {
    setState(() => _isOpening = true);
    try {
      final userId = ref.read(currentUserProvider)?.uid ?? '';
      final cards =
          await ref.read(collectionServiceProvider).openBooster(userId);
      setState(() {
        _cards = cards;
        _isOpening = false;
      });
      _revealCards();
    } catch (e) {
      setState(() => _isOpening = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  void _revealCards() {
    for (int i = 0; i < _cards.length; i++) {
      Future.delayed(Duration(milliseconds: 800 * i), () {
        if (mounted) {
          setState(() => _revealedCount = i + 1);
          if (i == _cards.length - 1) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) setState(() => _isFinished = true);
            });
          }
        }
      });
    }
  }

  Color _rarityColor(CardRarity rarity) {
    switch (rarity) {
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Ouvrir un Booster 🎁')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _cards.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🎁', style: TextStyle(fontSize: 80))
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.1, 1.1),
                            duration: 1.seconds),
                    const SizedBox(height: 32),
                    const Text(
                      'Ouvre un booster\npour 100 coins',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '3 cartes aléatoires vous attendent',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 40),
                    GradientButton(
                      text: 'Ouvrir (100🪙)',
                      onPressed: _openBooster,
                      isLoading: _isOpening,
                      gradient: AppColors.accentGradient,
                    ),
                  ],
                )
              : Column(
                  children: [
                    const Text(
                      '✨ Nouvelles cartes !',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_cards.length, (i) {
                          if (i >= _revealedCount) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text('❓',
                                    style: TextStyle(fontSize: 32)),
                              ),
                            );
                          }
                          final card = _cards[i];
                          final color = _rarityColor(card.rarity);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: color.withOpacity(0.6),
                                  width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.2),
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Text('🎤',
                                    style: TextStyle(fontSize: 32)),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        card.artistName,
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        card.title,
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                RarityBadge(rarity: card.rarity),
                              ],
                            ),
                          )
                              .animate()
                              .scale(
                                  duration: 400.ms,
                                  curve: Curves.elasticOut)
                              .fadeIn();
                        }),
                      ),
                    ),
                    if (_isFinished) ...[
                      GradientButton(
                        text: 'Ouvrir un autre',
                        onPressed: () {
                          setState(() {
                            _cards = [];
                            _revealedCount = 0;
                            _isFinished = false;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => context.go('/collection'),
                        child: const Text('Voir ma collection'),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
