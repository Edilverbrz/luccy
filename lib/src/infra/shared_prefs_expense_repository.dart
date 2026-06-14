import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../../src/domain/expense_repository.dart';
import '../../src/models/expense.dart';

class SharedPrefsExpenseRepository implements ExpenseRepository {
  static const _key = 'variable_expenses_v1';

  Future<SharedPreferences> _prefs() async => await SharedPreferences.getInstance();

  @override
  Future<void> addExpense(VariableExpense expense) async {
    final prefs = await _prefs();
    final list = prefs.getStringList(_key) ?? [];
    list.insert(0, jsonEncode(_toMap(expense)));
    await prefs.setStringList(_key, list);
  }

  @override
  Future<List<VariableExpense>> getExpenses() async {
    final prefs = await _prefs();
    final list = prefs.getStringList(_key) ?? [];
    return list.map((s) => _fromMap(jsonDecode(s))).toList();
  }

  Map<String, dynamic> _toMap(VariableExpense e) => {
        'id': e.id,
        'amount': e.amount,
        'description': e.description,
        'date': e.date,
      };

  VariableExpense _fromMap(Map m) => VariableExpense(
        id: m['id'] as int,
        amount: (m['amount'] as num).toDouble(),
        description: m['description'] as String,
        date: m['date'] as String,
      );
}
