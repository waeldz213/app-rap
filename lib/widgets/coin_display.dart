import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'animated_counter.dart';

class CoinDisplay extends StatelessWidget {
  final int coins;
  final bool animate;

  const CoinDisplay({super.key, required this.coins, this.animate = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🪙', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          if (animate)
            AnimatedCounter(
              value: coins,
              style: const TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            )
          else
            Text(
              coins.toString(),
              style: const TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
        ],
      ),
    );
  }
}
