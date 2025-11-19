import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../services/patient_service.dart';
import '../services/user_service.dart';
import '../widgets/ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Patient> patients = [];
  String query = '';

  Future<void> _load() async {
    final list = await (query.isEmpty
        ? PatientService.all()
        : PatientService.search(query));
    setState(() => patients = list);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _logout() async {
    await UserService.setCurrent(null);
    if (mounted) Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed('/patient/register');
          _load();
        },
        child: const Icon(Icons.person_add_alt_1),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Buscar paciente',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (v) {
                  query = v;
                  _load();
                },
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _load,
                child: ListView.separated(
                  itemCount: patients.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final p = patients[i];
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(p.name),
                      subtitle: Text('Idade: ${p.age}${p.notes != null ? " · ${p.notes}" : ""}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        await Navigator.of(context)
                            .pushNamed('/patient/detail', arguments: p);
                        _load();
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: PrimaryButton(
                text: 'Histórico Geral',
                filled: false,
                onPressed: () => Navigator.of(context).pushNamed('/history'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}