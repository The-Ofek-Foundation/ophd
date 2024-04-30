import 'package:universal_html/html.dart';

void replaceHistoryState(String title, String url) {
  window.history.replaceState(null, title, url);
}