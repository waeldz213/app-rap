import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/theme.dart';

enum AnswerState { idle, selected, correct, wrong }

class AnswerButton extends StatefulWidget {
  final String text;
  final AnswerState state;
  final VoidCallback? onTap;
  final int index;

  const AnswerButton({
    super.key,
    required this.text,
    this.state = AnswerState.idle,
    this.onTap,
    this.index = 0,
  });

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {
  bool _isPressed = false;

  Color get _backgroundColor {
    switch (widget.state) {
      case AnswerState.correct:
        return AppTheme.success.withOpacity(0.2);
      case AnswerState.wrong:
        return AppTheme.error.withOpacity(0.2);
      case AnswerState.selected:
        return AppTheme.primary.withOpacity(0.2);
      case AnswerState.idle:
        return AppTheme.surfaceVariant;
    }
  }

  Color get _borderColor {
    switch (widget.state) {
      case AnswerState.correct:
        return AppTheme.success;
      case AnswerState.wrong:
        return AppTheme.error;
      case AnswerState.selected:
        return AppTheme.primary;
      case AnswerState.idle:
        return Colors.white.withOpacity(0.1);
    }
  }

  IconData? get _trailingIcon {
    switch (widget.state) {
      case AnswerState.correct:
        return Icons.check_circle;
      case AnswerState.wrong:
        return Icons.cancel;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null
          ? (_) => setState(() => _isPressed = true)
          : null,
      onTapUp: widget.onTap != null
          ? (_) {
              setState(() => _isPressed = false);
              widget.onTap?.call();
            }
          : null,
      onTapCancel: widget.onTap != null
          ? () => setState(() => _isPressed = false)
          : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
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
                  widget.text,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (_trailingIcon != null)
                Icon(
                  _trailingIcon,
                  color: widget.state == AnswerState.correct
                      ? AppTheme.success
                      : AppTheme.error,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    ).animate(delay: (widget.index * 80).ms).fadeIn(duration: 300.ms).slideX(
          begin: 0.05,
          end: 0,
          curve: Curves.easeOut,
        );
  }
}
