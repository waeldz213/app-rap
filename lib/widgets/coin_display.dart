import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/theme.dart';

class CoinDisplay extends StatefulWidget {
  final int amount;
  final bool compact;

  const CoinDisplay({
    super.key,
    required this.amount,
    this.compact = false,
  });

  @override
  State<CoinDisplay> createState() => _CoinDisplayState();
}

class _CoinDisplayState extends State<CoinDisplay> {
  late int _previousAmount;

  @override
  void initState() {
    super.initState();
    _previousAmount = widget.amount;
  }

  @override
  void didUpdateWidget(CoinDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _previousAmount = oldWidget.amount;
  }

  @override
  Widget build(BuildContext context) {
    final hasChanged = widget.amount != _previousAmount;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.compact ? 8 : 12,
        vertical: widget.compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.accent.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🪙',
            style: TextStyle(fontSize: widget.compact ? 14 : 16),
          ),
          const SizedBox(width: 4),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position:
                    Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero)
                        .animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: Text(
              widget.amount.toString(),
              key: ValueKey(widget.amount),
              style: TextStyle(
                color: AppTheme.accent,
                fontSize: widget.compact ? 13 : 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ).animate(target: hasChanged ? 1 : 0).shake(duration: 300.ms);
  }
}
