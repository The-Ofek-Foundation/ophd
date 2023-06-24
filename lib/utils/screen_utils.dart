import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

Card buildCard(Widget content) {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: buildContent(content)
  );
}

Padding buildContent(Widget content) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: content
  );
}

Widget buildCardIfWideEnough(Widget content, {double width = 500}) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth > width) {
        return Center(
          child: SingleChildScrollView(
            child: buildCard(content),
          ),
        );
      } else {
        return Center(
          child: SingleChildScrollView(
            child: buildContent(content),
          ),
        );
      }
    },
  );
}

IconButton buildIconButton(IconData icon, String url, String tooltip) {
  return IconButton(
    icon: Icon(icon),
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
