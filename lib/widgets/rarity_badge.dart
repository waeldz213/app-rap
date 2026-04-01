import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../config/theme.dart';

class RarityBadge extends StatelessWidget {
  final CardRarity rarity;
  final bool small;

  const RarityBadge({
    super.key,
    required this.rarity,
    this.small = false,
  });

  Color get _color {
    switch (rarity) {
      case CardRarity.commune:
        return AppTheme.commune;
      case CardRarity.rare:
        return AppTheme.rare;
      case CardRarity.epic:
        return AppTheme.epic;
      case CardRarity.legendary:
        return AppTheme.legendary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 10,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.2),
        border: Border.all(color: _color, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        rarity.displayName.toUpperCase(),
        style: TextStyle(
          color: _color,
          fontSize: small ? 9 : 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
