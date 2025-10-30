import 'package:flutter/material.dart';
import '../models/patient.dart';
import 'classification_noncritical.dart';

class PatientRegisterScreen extends StatefulWidget {
  const PatientRegisterScreen({super.key});

  @override
  State<PatientRegisterScreen> createState() => _PatientRegisterScreenState();
}

class _PatientRegisterScreenState extends State<PatientRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String gender = 'Masculino';
  int? age;
  double? weight;
  double? height;
  String ward = '';

  double? _parseDouble(String v) =>
      double.tryParse(v.replaceAll(',', '.').trim());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Paciente')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Nome do paciente'),
                onChanged: (v) => name = v.trim(),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: gender,
                decoration: const InputDecoration(labelText: 'Sexo'),
                items: const ['Masculino', 'Feminino']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) => setState(() => gender = v ?? 'Masculino'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
                onChanged: (v) => age = int.tryParse(v.trim()),
                // opcional: se preencher, precisa ser válido
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  final parsed = int.tryParse(v.trim());
                  if (parsed == null || parsed < 0) return 'Idade inválida';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.number,
                onChanged: (v) => weight = _parseDouble(v),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  final parsed = _parseDouble(v);
                  if (parsed == null || parsed <= 0) return 'Peso inválido';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Altura (cm)'),
                keyboardType: TextInputType.number,
                onChanged: (v) => height = _parseDouble(v),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  final parsed = _parseDouble(v);
                  if (parsed == null || parsed <= 0) return 'Altura inválida';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Local de internação'),
                onChanged: (v) => ward = v.trim(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final patient = Patient(
                      id: DateTime.now()
                          .millisecondsSinceEpoch
                          .toString(), // id simples
                      name: name,
                      gender: gender,
                      age: age,
                      weightKg: weight,
                      heightCm: height,
                      ward: ward,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Paciente cadastrado com sucesso!'),
                      ),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ClassificationNonCriticalScreen(patient: patient),
                      ),
                    );
                  }
                },
                child: const Text('Salvar Cadastro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}