import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;
import 'package:js/js_util.dart' as js_util;

Future<void> launchAssetInNewTab(String assetPath, String fileType) async {
  final byteData = await rootBundle.load(assetPath);
  final bytes = byteData.buffer.asUint8List();
  // Convert the Dart list to a JSArray<BlobPart> for the web.Blob constructor.
  final parts = js_util.jsify([bytes]);
  final blob = web.Blob(parts, web.BlobPropertyBag(type: fileType));
  final objectUrl = web.URL.createObjectURL(blob);
  web.window.open(objectUrl, '_blank');
  web.URL.revokeObjectURL(objectUrl);
}
