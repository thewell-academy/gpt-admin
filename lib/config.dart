// lib/config.dart
import 'dart:js_util' as js_util;
import 'dart:html';

class Config {
  static late String serverUrl;

  static void loadServerUrl() {
    try {
      // Access the JavaScript 'window.serverConfig.serverUrl'
      serverUrl = js_util.getProperty(window, 'serverConfig')['serverUrl'] as String;
    } catch (e) {
      // Fallback URL in case of an error
      serverUrl = "http://localhost:8000";
    }
  }
}