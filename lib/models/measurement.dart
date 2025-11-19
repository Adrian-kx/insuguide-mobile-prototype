enum MeasurementType { glucose, creatinine }

class Measurement {
  final MeasurementType type;
  final num value; // será arredondado para par
  final DateTime at;

  Measurement({required this.type, required this.value, required this.at});

  factory Measurement.fromJson(Map<String, dynamic> j) => Measurement(
        type: MeasurementType.values.firstWhere(
          (e) => e.name == j['type'],
          orElse: () => MeasurementType.glucose,
        ),
        value: j['value'],
        at: DateTime.parse(j['at']),
      );

  Map<String, dynamic> toJson() =>
      {'type': type.name, 'value': value, 'at': at.toIso8601String()};
}