import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/luccy_controller.dart';

class SetupScreen extends StatefulWidget {
  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _incomeCtrl = TextEditingController();
  final _fixedDesc = TextEditingController();
  final _fixedAmount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<LuccyController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Configura tu mes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tus Ingresos', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _incomeCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(prefixText: '\$ '),
                      onChanged: (v) {
                        ctrl.setIncome(double.tryParse(v) ?? 0.0);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Gastos Fijos', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(ctrl.totalFixedExpenses.toStringAsFixed(2))
                      ],
                    ),
                    const SizedBox(height: 8),
                    for (var item in ctrl.fixedExpenses)
                      ListTile(
                        title: Text(item.description),
                        trailing: Row(mainAxisSize: MainAxisSize.min, children: [Text(item.amount.toStringAsFixed(2)), IconButton(icon: const Icon(Icons.delete), onPressed: () => ctrl.removeFixedExpense(item.id))]),
                      ),
                    const Divider(),
                    Row(children: [
                      Expanded(child: TextField(controller: _fixedDesc, decoration: const InputDecoration(hintText: 'Ej. Renta'))),
                      const SizedBox(width: 8),
                      SizedBox(width: 120, child: TextField(controller: _fixedAmount, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: '0.00'))),
                      IconButton(
                          onPressed: () {
                            final amt = double.tryParse(_fixedAmount.text) ?? 0.0;
                            if (amt > 0 && _fixedDesc.text.trim().isNotEmpty) {
                              ctrl.addFixedExpense(_fixedDesc.text.trim(), amt);
                              _fixedDesc.clear();
                              _fixedAmount.clear();
                            }
                          },
                          icon: const Icon(Icons.add)),
                    ])
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () { ctrl.finishSetup(); }, child: const Text('¡Todo listo, comenzar!'))
          ],
        ),
      ),
    );
  }
}
