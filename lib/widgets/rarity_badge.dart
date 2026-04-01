import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/card_model.dart';

class RarityBadge extends StatelessWidget {
  final CardRarity rarity;
  final bool small;

  const RarityBadge({super.key, required this.rarity, this.small = false});

  Color get _color {
    switch (rarity) {
      case CardRarity.commune:
        return AppColors.commune;
      case CardRarity.rare:
        return AppColors.rare;
      case CardRarity.epique:
        return AppColors.epique;
      case CardRarity.legendaire:
        return AppColors.legendaire;
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
        color: _color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.6)),
      ),
      child: Text(
        rarity.label,
        style: TextStyle(
          color: _color,
          fontSize: small ? 10 : 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
