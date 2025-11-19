import 'package:flutter/material.dart';
import '../models/measurement.dart';
import '../models/patient.dart';
import '../services/patient_service.dart';

class PatientDetailScreen extends StatefulWidget {
  final Patient patient;
  const PatientDetailScreen({super.key, required this.patient});

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  late Patient p;

  @override
  void initState() {
    super.initState();
    p = widget.patient;
  }

  Future<void> _add(MeasurementType t) async {
    final ctrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Adicionar ${t == MeasurementType.glucose ? "Glicose" : "Creatinina"}'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Valor'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              final v = num.tryParse(ctrl.text.replaceAll(',', '.'));
              if (v == null) return;
              await PatientService.addMeasurement(
                patientId: p.id,
                type: t,
                value: v,
              );
              if (context.mounted) Navigator.pop(context);
              final refreshed = (await PatientService.all()).firstWhere((e) => e.id == p.id);
              setState(() => p = refreshed);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ms = p.measurements;
    return Scaffold(
      appBar: AppBar(title: Text(p.name)),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'g',
            onPressed: () => _add(MeasurementType.glucose),
            icon: const Icon(Icons.bloodtype),
            label: const Text('Glicose'),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'c',
            onPressed: () => _add(MeasurementType.creatinine),
            icon: const Icon(Icons.science),
            label: const Text('Creatinina'),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: ms.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final m = ms[ms.length - 1 - i]; // mais recente primeiro
          return ListTile(
            leading: Icon(m.type == MeasurementType.glucose ? Icons.bloodtype : Icons.science),
            title: Text('${m.type.name.toUpperCase()} — ${m.value}'),
            subtitle: Text(m.at.toLocal().toString()),
          );
        },
      ),
    );
  }
}