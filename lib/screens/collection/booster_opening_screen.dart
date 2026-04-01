import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../models/card_model.dart';
import '../../config/theme.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/rarity_badge.dart';

class BoosterOpeningScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? extra;

  const BoosterOpeningScreen({super.key, this.extra});

  @override
  ConsumerState<BoosterOpeningScreen> createState() =>
      _BoosterOpeningScreenState();
}

class _BoosterOpeningScreenState extends ConsumerState<BoosterOpeningScreen> {
  bool _isOpening = false;
  bool _isRevealing = false;
  int _revealedCount = 0;

  // Demo cards for UI - in real app these come from the openBooster Cloud Function
  final List<_DemoCard> _cards = [
    _DemoCard(name: 'Booba', rarity: CardRarity.epic, emoji: '👑'),
    _DemoCard(name: 'SCH', rarity: CardRarity.rare, emoji: '🔥'),
    _DemoCard(name: 'Ninho', rarity: CardRarity.commune, emoji: '🎤'),
  ];

  Future<void> _openBooster() async {
    setState(() {
      _isOpening = true;
    });
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _isOpening = false;
      _isRevealing = true;
    });
    // Reveal cards one by one
    for (int i = 0; i < _cards.length; i++) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) setState(() => _revealedCount = i + 1);
    }
  }

  Color _rarityGlow(CardRarity rarity) {
    switch (rarity) {
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

  Gradient _rarityGradient(CardRarity rarity) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Ouverture Booster'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isRevealing) ...[
                // Booster pack display
                Container(
                  width: 180,
                  height: 260,
                  decoration: BoxDecoration(
                    gradient: AppTheme.premiumGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('🎁', style: TextStyle(fontSize: 64)),
                      SizedBox(height: 12),
                      Text(
                        'BOOSTER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                        ),
                      ),
                      Text(
                        '3 cartes',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                )
                    .animate(target: _isOpening ? 1 : 0)
                    .shake(duration: 600.ms)
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      curve: Curves.elasticOut,
                    ),
                const SizedBox(height: 48),
                GradientButton(
                  gradient: AppTheme.goldGradient,
                  onPressed: _isOpening ? null : _openBooster,
                  isLoading: _isOpening,
                  text: '✨ Ouvrir le Booster',
                ),
              ] else ...[
                // Revealed cards
                const Text(
                  'Vos cartes!',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ).animate().fadeIn(),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _cards.asMap().entries.map((entry) {
                    final i = entry.key;
                    final card = entry.value;
                    final isRevealed = i < _revealedCount;

                    return AnimatedOpacity(
                      opacity: isRevealed ? 1 : 0,
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: 100,
                        height: 150,
                        decoration: BoxDecoration(
                          gradient: _rarityGradient(card.rarity),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: _rarityGlow(card.rarity).withOpacity(0.5),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(card.emoji,
                                style: const TextStyle(fontSize: 36)),
                            const SizedBox(height: 6),
                            Text(
                              card.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            RarityBadge(rarity: card.rarity, small: true),
                          ],
                        ),
                      ).animate(target: isRevealed ? 1 : 0).scale(
                            begin: const Offset(0.5, 0.5),
                            end: const Offset(1, 1),
                            duration: 500.ms,
                            curve: Curves.elasticOut,
                          ),
                    );
                  }).toList(),
                ),
                if (_revealedCount >= _cards.length) ...[
                  const SizedBox(height: 48),
                  GradientButton(
                    gradient: AppTheme.premiumGradient,
                    onPressed: () => context.go('/collection'),
                    text: 'Voir ma collection',
                  ).animate().fadeIn(delay: 400.ms),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoCard {
  final String name;
  final CardRarity rarity;
  final String emoji;

  const _DemoCard({
    required this.name,
    required this.rarity,
    required this.emoji,
  });
}
