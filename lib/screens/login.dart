import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../widgets/ui.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool creating = false;

  Future<void> _submit() async {
    final u = userCtrl.text.trim();
    final p = passCtrl.text.trim();
    if (u.isEmpty || p.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha usuário e senha')),
      );
      return;
    }
    final existing = await UserService.get(u);
    if (creating) {
      await UserService.upsert(AppUser(username: u, password: p));
      await UserService.setCurrent(u);
      if (mounted) Navigator.of(context).pushReplacementNamed('/home');
    } else {
      if (existing == null || existing.password != p) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciais inválidas')),
        );
        return;
      }
      await UserService.setCurrent(u);
      if (mounted) Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.health_and_safety, size: 64),
                  const SizedBox(height: 12),
                  Text('InsuGuide – Acesso',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 24),
                  TextField(controller: userCtrl, decoration: const InputDecoration(labelText: 'Usuário')),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Senha'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Switch(
                        value: creating,
                        onChanged: (v) => setState(() => creating = v),
                      ),
                      const Text('Criar nova conta'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(text: creating ? 'Criar e entrar' : 'Entrar', onPressed: _submit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}