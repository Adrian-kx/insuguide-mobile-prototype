import 'package:flutter/material.dart';
import 'screens/patient_register.dart';

void main() {
  runApp(const InsuGuideApp());
}

class InsuGuideApp extends StatelessWidget {
  const InsuGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InsuGuide Mobile Prototype',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('InsuGuide Mobile')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PatientRegisterScreen()),
            );
          },
          child: const Text('Cadastrar Paciente'),
        ),
      ),
    );
  }
}