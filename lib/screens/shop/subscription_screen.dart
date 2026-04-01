import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../widgets/gradient_button.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Premium')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('👑', style: TextStyle(fontSize: 64))
                .animate()
                .scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 16),
            const Text(
              'App Rap Premium',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 8),
            const Text(
              'Accès illimité à toute la culture rap',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 250.ms),
            const SizedBox(height: 32),
            // Features
            ...[
              ('🎵', 'Tous les packs débloqués', 'Plus de 20 packs exclusifs'),
              ('📦', 'Boosters hebdomadaires', '2 boosters offerts par semaine'),
              ('⚔️', 'Duels illimités', 'Affrontez qui vous voulez'),
              ('🏆', 'Badge Premium', 'Montrez votre statut'),
              ('🚫', 'Sans publicités', 'Expérience épurée'),
            ]
                .asMap()
                .entries
                .map((entry) => _FeatureRow(
                      emoji: entry.value.$1,
                      title: entry.value.$2,
                      subtitle: entry.value.$3,
                    )
                        .animate(delay: (300 + entry.key * 80).ms)
                        .fadeIn()
                        .slideX(begin: -0.1)),
            const SizedBox(height: 32),
            // Price options
            _PriceOption(
              title: 'Mensuel',
              price: '4.99€/mois',
              subtitle: 'Annulable à tout moment',
              gradient: AppTheme.premiumGradient,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Abonnement mensuel bientôt disponible')),
                );
              },
            ).animate().fadeIn(delay: 700.ms),
            const SizedBox(height: 12),
            _PriceOption(
              title: 'Annuel 🔥',
              price: '39.99€/an',
              subtitle: 'Économisez 33%',
              gradient: AppTheme.goldGradient,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Abonnement annuel bientôt disponible')),
                );
              },
            ).animate().fadeIn(delay: 800.ms),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Restauration des achats...')),
                );
              },
              child: const Text(
                'Restaurer les achats',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ).animate().fadeIn(delay: 900.ms),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    final uri = Uri.parse('https://example.com/terms');
                    if (await canLaunchUrl(uri)) await launchUrl(uri);
                  },
                  child: const Text(
                    'CGU',
                    style: TextStyle(
                        color: AppTheme.textSecondary, fontSize: 12),
                  ),
                ),
                const Text('·',
                    style: TextStyle(color: AppTheme.textSecondary)),
                TextButton(
                  onPressed: () async {
                    final uri = Uri.parse('https://example.com/privacy');
                    if (await canLaunchUrl(uri)) await launchUrl(uri);
                  },
                  child: const Text(
                    'Confidentialité',
                    style: TextStyle(
                        color: AppTheme.textSecondary, fontSize: 12),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 950.ms),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;

  const _FeatureRow({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceOption extends StatelessWidget {
  final String title;
  final String price;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback onTap;

  const _PriceOption({
    required this.title,
    required this.price,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
            Text(
              price,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
