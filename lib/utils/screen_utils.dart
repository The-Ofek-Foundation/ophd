import 'package:flutter/services.dart';
import 'package:universal_html/html.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<void> launchURL(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> launchAssetInNewTab(String assetPath, String fileType) async {
  final bytes = await rootBundle.load(assetPath);

  final blob = Blob([bytes], fileType);
  final url = Url.createObjectUrlFromBlob(blob);
  window.open(url, '_blank');
  Url.revokeObjectUrl(url);
}
