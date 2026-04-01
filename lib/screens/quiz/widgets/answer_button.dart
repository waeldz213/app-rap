import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/theme.dart';

enum AnswerState { idle, correct, wrong, revealed }

class AnswerButton extends StatelessWidget {
  final String text;
  final AnswerState state;
  final VoidCallback? onPressed;
  final int index;

  const AnswerButton({
    super.key,
    required this.text,
    required this.state,
    this.onPressed,
    this.index = 0,
  });

  Color get _backgroundColor {
    switch (state) {
      case AnswerState.correct:
        return AppColors.success.withOpacity(0.2);
      case AnswerState.wrong:
        return AppColors.error.withOpacity(0.2);
      case AnswerState.revealed:
        return AppColors.success.withOpacity(0.1);
      default:
        return AppColors.surfaceVariant;
    }
  }

  Color get _borderColor {
    switch (state) {
      case AnswerState.correct:
        return AppColors.success;
      case AnswerState.wrong:
        return AppColors.error;
      case AnswerState.revealed:
        return AppColors.success.withOpacity(0.5);
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: state == AnswerState.idle ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (state == AnswerState.correct)
              const Icon(Icons.check_circle,
                  color: AppColors.success, size: 20),
            if (state == AnswerState.wrong)
              const Icon(Icons.cancel, color: AppColors.error, size: 20),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 100 * index))
        .fadeIn(duration: 200.ms)
        .slideX(begin: 0.1, end: 0);
  }
}
