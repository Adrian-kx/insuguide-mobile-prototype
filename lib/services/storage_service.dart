class StorageService {
  // Simula o armazenamento local (ex.: Hive ou SharedPreferences).
  final List<Map<String, dynamic>> _storage = [];

  void saveData(Map<String, dynamic> data) {
    _storage.add(data);
  }

  List<Map<String, dynamic>> getData() {
    return _storage;
  }
}
