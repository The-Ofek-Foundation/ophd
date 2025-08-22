// Conditional export for web-specific history state replacement.
export 'replace_history_state_stub.dart'
if (dart.library.js_interop) 'replace_history_state_web.dart';