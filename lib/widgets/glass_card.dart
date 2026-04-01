import 'dart:ui';
import 'package:flutter/material.dart';
import '../config/theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final bool showGradientBorder;
  final Gradient? borderGradient;
  final double blurSigma;
  final double? width;
  final double? height;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.showGradientBorder = false,
    this.borderGradient,
    this.blurSigma = 10,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor ??
                AppTheme.surfaceVariant.withOpacity(0.8),
            borderRadius: BorderRadius.circular(borderRadius),
            border: showGradientBorder
                ? null
                : Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );

    if (showGradientBorder) {
      card = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: borderGradient ?? AppTheme.premiumGradient,
        ),
        padding: const EdgeInsets.all(1.5),
        child: card,
      );
    }

    return card;
  }
}
