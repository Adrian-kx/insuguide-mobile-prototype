import 'measurement.dart';

class Patient {
  final String id;
  String name;

  // já existia
  int age;

  // NOVOS (todos opcionais p/ compatibilidade)
  String gender;          // "Masculino", "Feminino", etc.
  double? weightKg;       // peso (para TDD e IMC)
  double? heightCm;       // altura (para IMC)
  String ward;            // setor/leito

  String? notes;
  final List<Measurement> measurements;

  double? get bmi {
    if (weightKg == null || heightCm == null || heightCm == 0) return null;
    final h = (heightCm! / 100.0);
    return weightKg! / (h * h);
  }

  Patient({
    required this.id,
    required this.name,
    required this.age,
    this.gender = 'Indefinido',
    this.weightKg,
    this.heightCm,
    this.ward = '',
    this.notes,
    List<Measurement>? measurements,
  }) : measurements = measurements ?? [];

  factory Patient.fromJson(Map<String, dynamic> j) => Patient(
        id: j['id'],
        name: j['name'],
        age: j['age'],
        gender: (j['gender'] ?? 'Indefinido') as String,
        weightKg: (j['weightKg'] as num?)?.toDouble(),
        heightCm: (j['heightCm'] as num?)?.toDouble(),
        ward: (j['ward'] ?? '') as String,
        notes: j['notes'],
        measurements: (j['measurements'] as List? ?? [])
            .map((e) => Measurement.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'gender': gender,
        'weightKg': weightKg,
        'heightCm': heightCm,
        'ward': ward,
        'notes': notes,
        'measurements': measurements.map((m) => m.toJson()).toList(),
      };
}