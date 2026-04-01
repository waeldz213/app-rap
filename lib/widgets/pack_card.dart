import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../models/pack_model.dart';
import '../config/theme.dart';

class PackCard extends StatelessWidget {
  final PackModel pack;
  final bool compact;

  const PackCard({
    super.key,
    required this.pack,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/packs/${pack.id}'),
      child: Container(
        width: compact ? 160 : double.infinity,
        height: compact ? 200 : 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppTheme.surface,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (pack.imageUrl != null)
              CachedNetworkImage(
                imageUrl: pack.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppTheme.surfaceVariant,
                  child: const Center(
                    child: Icon(Icons.music_note,
                        color: AppTheme.textSecondary, size: 40),
                  ),
                ),
                errorWidget: (context, url, error) => _PlaceholderImage(),
              )
            else
              _PlaceholderImage(),
            // Gradient overlay
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xCC000000),
                  ],
                  stops: [0.4, 1.0],
                ),
              ),
            ),
            // Content
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      pack.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (pack.artist != null)
                      Text(
                        pack.artist!,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _DifficultyDots(difficulty: pack.difficulty),
                        const Spacer(),
                        _PremiumBadge(isPremium: pack.isPremium),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0);
  }
}

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.premiumGradient,
      ),
      child: const Center(
        child: Icon(Icons.headphones, color: Colors.white54, size: 48),
      ),
    );
  }
}

class _DifficultyDots extends StatelessWidget {
  final int difficulty;

  const _DifficultyDots({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i < difficulty
                ? AppTheme.accent
                : AppTheme.textSecondary.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}

class _PremiumBadge extends StatelessWidget {
  final bool isPremium;

  const _PremiumBadge({required this.isPremium});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        gradient: isPremium
            ? AppTheme.goldGradient
            : const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
              ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isPremium ? 'PREMIUM' : 'GRATUIT',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
