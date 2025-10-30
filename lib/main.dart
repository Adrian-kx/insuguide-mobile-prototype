import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/patient_register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insuguide',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/patient_register': (context) => const PatientRegisterScreen(),
      },
    );
  }
}