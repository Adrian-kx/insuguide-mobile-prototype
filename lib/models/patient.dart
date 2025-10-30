class Patient {
  final String id; // ex.: DateTime.now().millisecondsSinceEpoch.toString()
  final String name;
  final String gender; // 'Masculino' | 'Feminino'
  final int? age;
  final double? weightKg;
  final double? heightCm;
  final double? creatinine; // mg/dL (opcional, para versões futuras)
  final String ward;

  const Patient({
    required this.id,
    required this.name,
    required this.gender,
    this.age,
    this.weightKg,
    this.heightCm,
    this.creatinine,
    required this.ward,
  });

  double? get bmi {
    if (weightKg == null || heightCm == null || heightCm == 0) return null;
    final h = (heightCm! / 100.0);
    return weightKg! / (h * h);
  }
}