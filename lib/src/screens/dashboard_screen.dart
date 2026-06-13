import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/luccy_controller.dart';
import '../models/expense.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<LuccyController>();
    final status = ctrl.getLuccyStatus();
    return Scaffold(
      appBar: AppBar(title: const Text('Tu Resumen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Disponible para gastar', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 8),
                  Text(ctrl.currentAvailable.toStringAsFixed(2), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Presupuesto Libre'), Text(ctrl.freeBudget.toStringAsFixed(2))]),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: status.level == StatusLevel.critical
                  ? Colors.red[50]
                  : status.level == StatusLevel.danger
                      ? Colors.orange[50]
                      : status.level == StatusLevel.attention
                          ? Colors.yellow[50]
                          : Colors.teal[50],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(children: [
                  const Icon(Icons.info_outline),
                  const SizedBox(width: 12),
                  Expanded(child: Text(status.message)),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Consumo del presupuesto'), Text('${ctrl.percentageSpent.toStringAsFixed(0)}%')]),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: (ctrl.percentageSpent / 100).clamp(0.0, 1.0)),
                ]),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Gastos Recientes', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (ctrl.variableExpenses.isEmpty)
              Card(child: Padding(padding: const EdgeInsets.all(12.0), child: Text('No has registrado ningún gasto extra aún.')))
            else
              for (var e in ctrl.variableExpenses)
                ListTile(title: Text(e.description), subtitle: Text(e.date), trailing: Text('-${e.amount.toStringAsFixed(2)}'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddExpense(context),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
        ],
      ),
    );
  }

  void _openAddExpense(BuildContext context) {
    final _amt = TextEditingController();
    final _desc = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: _amt, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: '¿Cuánto gastaste?')),
          TextField(controller: _desc, decoration: const InputDecoration(labelText: '¿En qué?')),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              final amt = double.tryParse(_amt.text) ?? 0.0;
              if (amt > 0 && _desc.text.trim().isNotEmpty) {
                context.read<LuccyController>().addVariableExpense(amt, _desc.text.trim());
                Navigator.of(context).pop();
              }
            },
            child: const Text('Registrar'),
          )
        ]),
      ),
    );
  }
}
