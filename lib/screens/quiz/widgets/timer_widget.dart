import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class TimerWidget extends StatelessWidget {
  final int seconds;
  final int maxSeconds;

  const TimerWidget({
    super.key,
    required this.seconds,
    this.maxSeconds = 20,
  });

  Color get _color {
    final ratio = seconds / maxSeconds;
    if (ratio > 0.5) return AppColors.success;
    if (ratio > 0.25) return AppColors.accent;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 36,
          height: 36,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: seconds / maxSeconds,
                backgroundColor: AppColors.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(_color),
                strokeWidth: 3,
              ),
              Text(
                '$seconds',
                style: TextStyle(
                  color: _color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
