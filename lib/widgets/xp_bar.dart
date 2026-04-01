import 'package:flutter/material.dart';
import '../config/theme.dart';

class XpBar extends StatelessWidget {
  final int currentXp;
  final int level;
  final int xpPerLevel;

  const XpBar({
    super.key,
    required this.currentXp,
    required this.level,
    this.xpPerLevel = 1000,
  });

  double get _progress {
    final xpInLevel = currentXp % xpPerLevel;
    return xpInLevel / xpPerLevel;
  }

  @override
  Widget build(BuildContext context) {
    final xpInLevel = currentXp % xpPerLevel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Niveau $level',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            Text(
              '$xpInLevel / $xpPerLevel XP',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _progress,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
