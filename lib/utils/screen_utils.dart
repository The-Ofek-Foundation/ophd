// Shared utilities with conditional platform-specific implementation for web-only features.
import 'screen_utils_stub.dart'
if (dart.library.js_interop) 'screen_utils_web.dart' as impl;
import 'package:url_launcher/url_launcher_string.dart';

Future<void> launchURL(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> launchAssetInNewTab(String assetPath, String fileType) =>
    impl.launchAssetInNewTab(assetPath, fileType);
