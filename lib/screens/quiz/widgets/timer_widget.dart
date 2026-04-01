import 'dart:async';
import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class TimerWidget extends StatefulWidget {
  final int durationSeconds;
  final VoidCallback? onTimeout;
  final ValueChanged<int>? onTick;

  const TimerWidget({
    super.key,
    required this.durationSeconds,
    this.onTimeout,
    this.onTick,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;
  int _secondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.durationSeconds;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.durationSeconds),
    )..forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _secondsRemaining--;
      });
      widget.onTick?.call(_secondsRemaining);
      if (_secondsRemaining <= 0) {
        timer.cancel();
        widget.onTimeout?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  Color get _timerColor {
    final ratio = _secondsRemaining / widget.durationSeconds;
    if (ratio > 0.5) return AppTheme.success;
    if (ratio > 0.25) return AppTheme.accent;
    return AppTheme.error;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _secondsRemaining / widget.durationSeconds;

    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CircularProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                strokeWidth: 5,
                backgroundColor: AppTheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(_timerColor),
              );
            },
          ),
          Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: _timerColor,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              child: Text('$_secondsRemaining'),
            ),
          ),
        ],
      ),
    );
  }
}
