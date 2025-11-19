import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class JsonStorage {
  static Future<File> _file(String name) async {
    final dir = await getApplicationDocumentsDirectory();
    final f = File('${dir.path}/$name');
    if (!await f.exists()) {
      await f.create(recursive: true);
      await f.writeAsString(jsonEncode(_seed(name)));
    }
    return f;
  }

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
    final f = await _file(name);
    final txt = await f.readAsString();
    return jsonDecode(txt) as Map<String, dynamic>;
  }

  static Future<void> write(String name, Map<String, dynamic> data) async {
    final f = await _file(name);
    await f.writeAsString(jsonEncode(data));
  }
}