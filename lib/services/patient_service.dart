import '../models/measurement.dart';
import '../models/patient.dart';
import '../utils/rounding.dart';
import 'json_storage.dart';

class PatientService {
  static const _file = 'patients.json';

  static Future<List<Patient>> all() async {
    final j = await JsonStorage.read(_file);
    final list = (j['patients'] as List?) ?? [];
    return list
        .map((e) => Patient.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<void> saveAll(List<Patient> patients) async {
    final j = await JsonStorage.read(_file);
    j['patients'] = patients.map((p) => p.toJson()).toList();
    await JsonStorage.write(_file, j);
  }

  static Future<Patient> create({
    required String name,
    required int age,
    String? notes,
  }) async {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final p = Patient(id: id, name: name, age: age, notes: notes);
    final list = await all();
    list.add(p);
    await saveAll(list);
    return p;
  }

  static Future<void> addMeasurement({
    required String patientId,
    required MeasurementType type,
    required num value,
    DateTime? at,
  }) async {
    final list = await all();
    final idx = list.indexWhere((p) => p.id == patientId);
    if (idx < 0) return;
    final rounded = roundToNearestEven(value);
    list[idx].measurements.add(
      Measurement(type: type, value: rounded, at: at ?? DateTime.now()),
    );
    await saveAll(list);
  }

  static Future<List<Patient>> search(String q) async {
    final list = await all();
    final s = q.trim().toLowerCase();
    if (s.isEmpty) return list;
    return list
        .where((p) =>
            p.name.toLowerCase().contains(s) ||
            p.id.contains(s) ||
            (p.notes ?? '').toLowerCase().contains(s))
        .toList();
  }

  static Future<List<Map<String, dynamic>>> historyEvents() async {
    final list = await all();
    final events = <Map<String, dynamic>>[];
    for (final p in list) {
      for (final m in p.measurements) {
        events.add({
          'patientId': p.id,
          'patientName': p.name,
          'type': m.type.name,
          'value': m.value,
          'at': m.at.toIso8601String(),
        });
      }
    }
    events.sort((a, b) => (b['at'] as String).compareTo(a['at'] as String));
    return events;
  }
}