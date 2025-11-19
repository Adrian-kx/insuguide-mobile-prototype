import 'package:flutter/material.dart';
import '../services/patient_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> events = [];

  Future<void> _load() async {
    final e = await PatientService.historyEvents();
    setState(() => events = e);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico Geral')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView.separated(
          itemCount: events.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final e = events[i];
            return ListTile(
              leading: const Icon(Icons.history),
              title: Text('${e['patientName']} — ${e['type'].toString().toUpperCase()}'),
              subtitle: Text('${e['value']} · ${DateTime.parse(e['at']).toLocal()}'),
            );
          },
        ),
      ),
    );
  }
}