import 'package:web/web.dart' as web;

void replaceHistoryState(String title, String url) {
  // Use the real browser history API.
  web.window.history.replaceState(null, title, url);
}
