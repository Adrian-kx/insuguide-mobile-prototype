import 'package:flutter/material.dart';
import '../models/patient.dart';

class FollowUpDailyScreen extends StatefulWidget {
  const FollowUpDailyScreen({
    super.key,
    required this.patient,
    required this.basal,
    required this.prandialPerMeal,
  });

  final Patient patient;
  final double basal;
  final double prandialPerMeal;

  @override
  State<FollowUpDailyScreen> createState() => _FollowUpDailyScreenState();
}

class _FollowUpDailyScreenState extends State<FollowUpDailyScreen> {
  final List<_Reading> readings = [];
  final TextEditingController valueCtrl = TextEditingController();

  String suggestion = 'Sem leituras ainda.';

  void _addReading() {
    final v = double.tryParse(valueCtrl.text.replaceAll(',', '.'));
    if (v == null) return;
    setState(() {
      readings.add(_Reading(DateTime.now(), v));
      valueCtrl.clear();
      _recalcSuggestion();
    });
  }

  // Regras didáticas simples (POC):
  // média > 180 → sugerir +10% na basal
  // média < 80  → sugerir -10% na basal
  void _recalcSuggestion() {
    if (readings.isEmpty) {
      suggestion = 'Sem leituras ainda.';
      return;
    }
    final avg = readings.map((e) => e.value).reduce((a, b) => a + b) / readings.length;
    if (avg > 180) {
      final newBasal = widget.basal * 1.10;
      suggestion = 'Média ${avg.toStringAsFixed(0)} mg/dL → considerar aumentar basal para '
          '${newBasal.toStringAsFixed(1)} U (+10%).';
    } else if (avg < 80) {
      final newBasal = widget.basal * 0.90;
      suggestion = 'Média ${avg.toStringAsFixed(0)} mg/dL → considerar reduzir basal para '
          '${newBasal.toStringAsFixed(1)} U (-10%).';
    } else {
      suggestion = 'Média ${avg.toStringAsFixed(0)} mg/dL → manter esquema atual.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.patient;

    return Scaffold(
      appBar: AppBar(title: const Text('Acompanhamento Diário (Simulado)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Paciente: ${p.name}', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Basal atual: ${widget.basal.toStringAsFixed(1)} U'),
                Text('Prandial por refeição: ${widget.prandialPerMeal.toStringAsFixed(1)} U'),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Text('Inserir glicemia (mg/dL)', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: valueCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    hintText: 'Ex.: 145',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(onPressed: _addReading, child: const Text('Adicionar')),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Leituras registradas (${readings.length})'),
                const SizedBox(height: 8),
                if (readings.isEmpty)
                  const Text('Nenhuma leitura ainda.')
                else
                  ...readings.map((r) => ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text('${r.value.toStringAsFixed(0)} mg/dL'),
                        subtitle: Text('${r.when.hour.toString().padLeft(2, '0')}:'
                            '${r.when.minute.toString().padLeft(2, '0')} — '
                            '${r.when.day.toString().padLeft(2, '0')}/'
                            '${r.when.month.toString().padLeft(2, '0')}'),
                      )),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                suggestion,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DischargeScreen(patient: p)),
              );
            },
            child: const Text('Orientações de Alta'),
          ),
        ],
      ),
    );
  }
}

class DischargeScreen extends StatelessWidget {
  final Patient patient;

  const DischargeScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orientações de Alta')),
      body: Center(
        child: Text('Orientações para o paciente: ${patient.name}'),
      ),
    );
  }
}

class _Reading {
  final DateTime when;
  final double value;
  _Reading(this.when, this.value);
}