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
    onPressed: () => _launchURL(url),
    tooltip: tooltip,
  );
}

Future<void> _launchURL(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'Could not launch $url';
  }
}
