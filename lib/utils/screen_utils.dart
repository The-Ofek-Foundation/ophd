import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

Padding outerPadding(BuildContext context, Widget child) {
  double maxWidth = MediaQuery.of(context).size.width * 0.7;

  if (maxWidth < 500) maxWidth = 500;
  if (maxWidth > 1000) maxWidth = 1000;

  return Padding(
    padding: const EdgeInsets.all(16),
    child: Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child
    ),
  );
}

Padding buildCard(BuildContext context, Widget content) {
  return outerPadding(context, 
    Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: buildContent(context, content, withinCard: true)
    )
  );
}

Padding buildContent(BuildContext context, Widget content, {bool withinCard = false}) {
  if (withinCard) return Padding(padding: const EdgeInsets.all(16), child: content);

  return outerPadding(context, content);
}

Widget buildCardIfWideEnough(BuildContext context, Widget content, {double width = 500}) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth > width) {
        return Center(
          child: SingleChildScrollView(
            child: buildCard(context, content),
          ),
        );
      } else {
        return Center(
          child: SingleChildScrollView(
            child: buildContent(context, content),
          ),
        );
      }
    },
  );
}

IconButton buildIconButton(dynamic icon, String url, String tooltip) {
  return IconButton(
    icon: icon is IconData ?
      Icon(icon) :
      ClipRRect(borderRadius: BorderRadius.circular(12), child: Image(image: icon, width: 24, height: 24)),
    onPressed: () => launchURL(url),
    tooltip: tooltip,
  );
}

Future<void> launchURL(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'Could not launch $url';
  }
}

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
        child: Tooltip(
          message: tooltip ?? 'Click to expand', // Default tooltip
          preferBelow: true,
          child: Image.asset(imagePath),
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