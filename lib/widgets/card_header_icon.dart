import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardHeaderIcon extends StatelessWidget {
  final IconData icon;
  final Color? backgroundColor;
  final double? size;

  const CardHeaderIcon({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    // Default size is 40 for Material icons, 32 for FontAwesome icons
    final double defaultSize = icon is FontAwesomeIcons ? 32.0 : 40.0;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: size ?? defaultSize,
        color: backgroundColor != null ? Colors.white : Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}