import 'package:flutter/material.dart';
import '../models/patient.dart';

class DischargeScreen extends StatelessWidget {
  const DischargeScreen({super.key, required this.patient});

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alta (Simulada)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Paciente: ${patient.name}', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                Text('Orientações Gerais (Didático):', style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 8),
                Text('• Manter monitorização domiciliar conforme orientação médica.'),
                Text('• Atenção a sinais de hipoglicemia (sudorese, tremores, confusão).'),
                Text('• Manter plano alimentar e horários regulares.'),
                Text('• Agendar retorno ambulatorial.'),
                SizedBox(height: 12),
              ]),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
            child: const Text('Concluir e voltar ao início'),
          ),
        ],
      ),
    );
  }
}