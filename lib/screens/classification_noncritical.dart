import 'package:flutter/material.dart';
import '../models/patient.dart';

class ClassificationNonCriticalScreen extends StatelessWidget {
  const ClassificationNonCriticalScreen({super.key, required this.patient});

  final Patient patient;

  String _bmiLabel(double bmi) {
    if (bmi < 18.5) return 'Baixo peso';
    if (bmi < 25) return 'Eutrofia';
    if (bmi < 30) return 'Sobrepeso';
    return 'Obesidade';
  }

  // TDD simulada: 0,4 U/kg (não crítico). Apenas para POC, sem validade clínica.
  double _calcTdd(double? weightKg) {
    if (weightKg == null) return 0;
    return (0.4 * weightKg);
  }

  @override
  Widget build(BuildContext context) {
    final bmi = patient.bmi;
    final tdd = _calcTdd(patient.weightKg);
    final bmiText = bmi == null ? '—' : bmi.toStringAsFixed(1);
    final bmiClass = bmi == null ? 'Indisponível' : _bmiLabel(bmi);

    return Scaffold(
      appBar: AppBar(title: const Text('Classificação (Não Crítico)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: DefaultTextStyle.merge(
                style: const TextStyle(fontSize: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Paciente: ${patient.name}', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('Sexo: ${patient.gender}'),
                    if (patient.age != null) Text('Idade: ${patient.age} anos'),
                    if (patient.weightKg != null) Text('Peso: ${patient.weightKg} kg'),
                    if (patient.heightCm != null) Text('Altura: ${patient.heightCm} cm'),
                    if (patient.ward.isNotEmpty) Text('Local de internação: ${patient.ward}'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('IMC: $bmiText', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text('Classificação por IMC: $bmiClass'),
                  const Divider(height: 24),
                  Text('Dose Total Diária (TDD) — Simulada', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text('Fórmula (POC): 0,4 U/kg'),
                  const SizedBox(height: 6),
                  Text('TDD estimada: ${tdd.toStringAsFixed(1)} U'),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PrescriptionSuggestionScreen(patient: patient, tdd: tdd),
                ),
              );
            },
            child: const Text('Gerar Prescrição (Simulada)'),
          ),
        ],
      ),
    );
  }
}

class PrescriptionSuggestionScreen extends StatelessWidget {
  final Patient patient;
  final double tdd;

  const PrescriptionSuggestionScreen({
    super.key,
    required this.patient,
    required this.tdd,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prescrição Simulada')),
      body: Center(
        child: Text(
          'Prescrição para ${patient.name} com TDD de ${tdd.toStringAsFixed(1)} U',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}