import 'dart:convert';
import 'dart:html' as html;

class JsonStorage {
  static Map<String, dynamic> _seed(String name) {
    switch (name) {
      case 'users.json':
        return {'users': [], 'current': null};
      case 'patients.json':
        return {'patients': []};
      case 'history.json':
        return {'events': []};
      default:
        return {};
    }
  }

  static Future<Map<String, dynamic>> read(String name) async {
    final s = html.window.localStorage[name];
    if (s == null) {
      final seed = _seed(name);
      html.window.localStorage[name] = jsonEncode(seed);
      return seed;
    }
    return jsonDecode(s) as Map<String, dynamic>;
  }

  static Future<void> write(String name, Map<String, dynamic> data) async {
    html.window.localStorage[name] = jsonEncode(data);
  }
}