import 'package:flutter/material.dart';

class ExpandableImage extends StatelessWidget {
  final String imagePath;
  final String? caption;
  final String? tooltip;

  const ExpandableImage(
      {Key? key, required this.imagePath, this.caption, this.tooltip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showModal(context, imagePath, caption),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10), // Set the clip radius
          child: Tooltip(
            message: tooltip ?? 'Click to expand', // Default tooltip
            preferBelow: true,
            child: Image.asset(imagePath),
          ),
        ),
      ),
    );
  }

  void _showModal(BuildContext context, String imagePath, String? caption) {
    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Hero(
                  tag: 'expandedImage',
                  transitionOnUserGestures: true,
                  child: InteractiveViewer(
                    child: Image.asset(imagePath),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                if (caption != null)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color:
                          Theme.of(context).colorScheme.background.withOpacity(0.8),
                      padding: const EdgeInsets.all(8.0),
                      child: SelectableText(
                        caption,
                        style: Theme.of(context).textTheme.displayMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
