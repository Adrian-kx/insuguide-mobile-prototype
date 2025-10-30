import 'package:flutter/material.dart';
import '../models/patient.dart';

class PrescriptionSuggestionScreen extends StatefulWidget {
  const PrescriptionSuggestionScreen({super.key, required this.patient, required this.tdd});

  final Patient patient;
  final double tdd; // calculada na etapa anterior

  @override
  State<PrescriptionSuggestionScreen> createState() => _PrescriptionSuggestionScreenState();
}

class _PrescriptionSuggestionScreenState extends State<PrescriptionSuggestionScreen> {
  // Divisão didática: 50% basal, 50% prandial (3 refeições)
  late double basal;
  late double prandialTotal;
  late double prandialPerMeal;

  // Opções simples de dieta/monitorização para o relatório
  String diet = 'Dieta hospitalar padrão';
  String monitoring = 'Glicemia capilar antes das refeições e ao deitar';

  @override
  void initState() {
    super.initState();
    basal = (widget.tdd * 0.50);
    prandialTotal = (widget.tdd * 0.50);
    prandialPerMeal = prandialTotal / 3.0;
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.patient;

    return Scaffold(
      appBar: AppBar(title: const Text('Prescrição (Simulada)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Resumo do Paciente', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.name),
                if (p.weightKg != null) Text('Peso: ${p.weightKg} kg'),
                if (p.heightCm != null) Text('Altura: ${p.heightCm} cm'),
                if (p.age != null) Text('Idade: ${p.age} anos'),
                Text('Sexo: ${p.gender}'),
                if (p.ward.isNotEmpty) Text('Internação: ${p.ward}'),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Text('Parâmetros', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                DropdownButtonFormField<String>(
                  value: diet,
                  items: const [
                    'Dieta hospitalar padrão',
                    'Dieta enteral',
                    'Zero oral (NPO)',
                  ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => diet = v ?? diet),
                  decoration: const InputDecoration(labelText: 'Dieta'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: monitoring,
                  items: const [
                    'Glicemia capilar antes das refeições e ao deitar',
                    'Glicemia capilar a cada 6 horas',
                  ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => monitoring = v ?? monitoring),
                  decoration: const InputDecoration(labelText: 'Monitorização'),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Text('Sugestão Didática', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('TDD estimada: ${widget.tdd.toStringAsFixed(1)} U'),
                const SizedBox(height: 8),
                Text('Basal (50% da TDD): ${basal.toStringAsFixed(1)} U à noite'),
                Text('Prandial total (50% da TDD): ${prandialTotal.toStringAsFixed(1)} U'),
                const SizedBox(height: 8),
                Text('Divisão prandial (rápida):'),
                Text('• Café: ${prandialPerMeal.toStringAsFixed(1)} U'),
                Text('• Almoço: ${prandialPerMeal.toStringAsFixed(1)} U'),
                Text('• Jantar: ${prandialPerMeal.toStringAsFixed(1)} U'),
                const Divider(height: 24),
              ]),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FollowUpDailyScreen(patient: p, basal: basal, prandialPerMeal: prandialPerMeal),
                ),
              );
            },
            child: const Text('Ir para Acompanhamento Diário'),
          ),
        ],
      ),
    );
  }
}

class FollowUpDailyScreen extends StatelessWidget {
  final Patient patient;
  final double basal;
  final double prandialPerMeal;

  const FollowUpDailyScreen({
    super.key,
    required this.patient,
    required this.basal,
    required this.prandialPerMeal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acompanhamento Diário')),
      body: Center(
        child: Text(
          'Paciente: ${patient.name}\nBasal: ${basal.toStringAsFixed(1)} U\nPrandial por refeição: ${prandialPerMeal.toStringAsFixed(1)} U',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}