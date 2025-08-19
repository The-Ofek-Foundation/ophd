// Shared utilities with conditional platform-specific implementation for web-only features.
import 'screen_utils_stub.dart'
    if (dart.library.html) 'screen_utils_web.dart' as _impl;
import 'package:url_launcher/url_launcher_string.dart';

Future<void> launchURL(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> launchAssetInNewTab(String assetPath, String fileType) =>
    _impl.launchAssetInNewTab(assetPath, fileType);
