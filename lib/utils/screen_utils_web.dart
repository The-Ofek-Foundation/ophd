import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop';

Future<void> launchAssetInNewTab(String assetPath, String fileType) async {
  final byteData = await rootBundle.load(assetPath);
  final bytes = byteData.buffer.asUint8List();
  final parts = <web.BlobPart>[bytes.toJS].toJS;
  final blob = web.Blob(parts, web.BlobPropertyBag(type: fileType));
  final objectUrl = web.URL.createObjectURL(blob);
  web.window.open(objectUrl, '_blank');
  web.URL.revokeObjectURL(objectUrl);
}
