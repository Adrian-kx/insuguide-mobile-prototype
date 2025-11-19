import '../models/user.dart';
import 'json_storage.dart';

class UserService {
  static const _file = 'users.json';

  static Future<List<AppUser>> all() async {
    final j = await JsonStorage.read(_file);
    final list = (j['users'] as List?) ?? [];
    return list.map((e) => AppUser.fromJson(Map<String, dynamic>.from(e))).toList();
    }

  static Future<void> upsert(AppUser u) async {
    final j = await JsonStorage.read(_file);
    final list = (j['users'] as List?) ?? [];
    final idx = list.indexWhere((e) => e['username'] == u.username);
    if (idx >= 0) {
      list[idx] = u.toJson();
    } else {
      list.add(u.toJson());
    }
    j['users'] = list;
    await JsonStorage.write(_file, j);
  }

  static Future<AppUser?> get(String username) async {
    final j = await JsonStorage.read(_file);
    final list = (j['users'] as List?) ?? [];
    final m = list.cast<Map>().firstWhere(
        (e) => e['username'] == username,
        orElse: () => {});
    if (m.isEmpty) return null;
    return AppUser.fromJson(Map<String, dynamic>.from(m));
  }

  static Future<void> setCurrent(String? username) async {
    final j = await JsonStorage.read(_file);
    j['current'] = username;
    await JsonStorage.write(_file, j);
  }

  static Future<String?> current() async {
    final j = await JsonStorage.read(_file);
    return j['current'] as String?;
  }
}