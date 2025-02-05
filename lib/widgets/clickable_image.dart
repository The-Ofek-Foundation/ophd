import 'package:flutter/material.dart';
import 'package:ophd/utils/screen_utils.dart';

class ClickableImage extends StatelessWidget {
  final ImageProvider<Object> image;
  final double? width;
  final double? height;
  final String link;
  final String? tooltip;

  const ClickableImage({
    super.key,
    required this.image,
    required this.link,
    this.width,
    this.height,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchURL(link),
      child: Tooltip(
        message: tooltip,
        child: Image(
          image: image,
          width: width,
          height: height,
        ),
      ),
    );
  }
}
