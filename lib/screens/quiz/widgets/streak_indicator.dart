import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/theme.dart';

class StreakIndicator extends StatefulWidget {
  final int streak;

  const StreakIndicator({super.key, required this.streak});

  @override
  State<StreakIndicator> createState() => _StreakIndicatorState();
}

class _StreakIndicatorState extends State<StreakIndicator> {
  int _previousStreak = 0;

  @override
  void didUpdateWidget(StreakIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _previousStreak = oldWidget.streak;
  }

  @override
  Widget build(BuildContext context) {
    final increased = widget.streak > _previousStreak && widget.streak > 0;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(widget.streak),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: widget.streak >= 5 ? AppTheme.fireGradient : null,
          color: widget.streak < 5 ? AppTheme.surfaceVariant : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔥', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 4),
            Text(
              '${widget.streak}x',
              style: TextStyle(
                color: widget.streak >= 5
                    ? Colors.white
                    : AppTheme.textSecondary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ).animate(target: increased ? 1 : 0).scale(
            begin: const Offset(1, 1),
            end: const Offset(1.2, 1.2),
            duration: 150.ms,
          ),
    );
  }
}
