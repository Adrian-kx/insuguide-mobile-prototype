import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/patient_register.dart';
import 'screens/patient_detail.dart';
import 'screens/history.dart';
import 'models/patient.dart';
import 'services/user_service.dart';
import 'widgets/ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InsuGuide',
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (_) => const Gate(),
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
        '/patient/register': (_) => const PatientRegisterScreen(),
        '/history': (_) => const HistoryScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/patient/detail') {
          final p = settings.arguments as Patient;
          return MaterialPageRoute(builder: (_) => PatientDetailScreen(patient: p));
        }
        return null;
      },
    );
  }
}

class Gate extends StatefulWidget {
  const Gate({super.key});
  @override
  State<Gate> createState() => _GateState();
}

class _GateState extends State<Gate> {
  @override
  void initState() {
    super.initState();
    _decide();
  }

  Future<void> _decide() async {
    final current = await UserService.current();
    if (!mounted) return;
    if (current == null) {
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}