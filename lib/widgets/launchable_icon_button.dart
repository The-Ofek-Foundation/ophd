import 'package:flutter/material.dart';
import 'package:ophd/utils/screen_utils.dart';

class LaunchableIconButton extends StatelessWidget {
  final dynamic icon;
  final String url;
  final String tooltip;
  final double iconSize;

  const LaunchableIconButton({
    Key? key,
    required this.icon,
    required this.url,
    required this.tooltip,
    this.iconSize = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon is IconData
          ? Icon(icon, size: iconSize)
          : ClipRRect(
              borderRadius: BorderRadius.circular(iconSize / 2),
              child: Image(image: icon, width: iconSize, height: iconSize)),
      onPressed: () => launchURL(url),
      tooltip: tooltip,
    );
  }
}
