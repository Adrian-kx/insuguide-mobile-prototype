// lib/screens/patient_register.dart
import 'package:flutter/material.dart';
import '../services/patient_service.dart';
import '../widgets/ui.dart';

class PatientRegisterScreen extends StatefulWidget {
  const PatientRegisterScreen({super.key});

  @override
  State<PatientRegisterScreen> createState() => _PatientRegisterScreenState();
}

class _PatientRegisterScreenState extends State<PatientRegisterScreen> {
  // controllers devem ficar dentro do State (não no topo do arquivo)
  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  final genderCtrl = ValueNotifier<String>('Masculino');
  final weightCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final wardCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    ageCtrl.dispose();
    notesCtrl.dispose();
    weightCtrl.dispose();
    heightCtrl.dispose();
    wardCtrl.dispose();
    genderCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final n = nameCtrl.text.trim();
    final a = int.tryParse(ageCtrl.text.trim()) ?? -1;

    if (n.isEmpty || a <= 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome e idade válidos são obrigatórios')),
      );
      return;
    }

    final weight =
        double.tryParse(weightCtrl.text.trim().replaceAll(',', '.'));
    final height =
        double.tryParse(heightCtrl.text.trim().replaceAll(',', '.'));
    final notes =
        notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim();

    // cria paciente (com os campos básicos)
    final p = await PatientService.create(name: n, age: a, notes: notes);

    // persiste os extras (sexo, peso, altura, leito)
    final all = await PatientService.all();
    final idx = all.indexWhere((e) => e.id == p.id);
    if (idx >= 0) {
      all[idx]
        ..gender = genderCtrl.value
        ..weightKg = weight
        ..heightCm = height
        ..ward = wardCtrl.text.trim();
      await PatientService.saveAll(all);
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Paciente')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Nome'),
              controller: nameCtrl,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Idade'),
              controller: ageCtrl,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<String>(
              valueListenable: genderCtrl,
              builder: (context, value, _) {
                return DropdownButtonFormField<String>(
                  value: value,
                  items: const [
                    DropdownMenuItem(
                        value: 'Masculino', child: Text('Masculino')),
                    DropdownMenuItem(
                        value: 'Feminino', child: Text('Feminino')),
                    DropdownMenuItem(
                        value: 'Indefinido', child: Text('Indefinido')),
                  ],
                  onChanged: (v) => genderCtrl.value = v ?? 'Indefinido',
                  decoration: const InputDecoration(labelText: 'Sexo'),
                );
              },
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Peso (kg)'),
              controller: weightCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Altura (cm)'),
              controller: heightCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Setor/Leito'),
              controller: wardCtrl,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration:
                  const InputDecoration(labelText: 'Observações'),
              controller: notesCtrl,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            PrimaryButton(text: 'Salvar', onPressed: _save),
          ],
        ),
      ),
    );
  }
}