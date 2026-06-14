import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../domain/budget.dart';
import '../domain/expense_repository.dart';
import '../application/add_expense.dart';
import '../infra/in_memory_expense_repository.dart';

enum AuthState { login, register, authenticated }
enum SetupState { notStarted, inProgress, completed }

class LuccyController extends ChangeNotifier {
  final ExpenseRepository repository;

  LuccyController({ExpenseRepository? repository}) : repository = repository ?? InMemoryExpenseRepository();
  // Auth / Setup
  AuthState authState = AuthState.login;
  SetupState setupState = SetupState.notStarted;

  // User data
  String userName = '';
  double income = 0.0;
  final List<FixedExpense> fixedExpenses = [];
  final List<VariableExpense> variableExpenses = [];

  // UI
  String activeTab = 'dashboard';

  // --- Calculations ---
  double get totalFixedExpenses => Budget(income: income, fixedExpenses: fixedExpenses, variableExpenses: variableExpenses).totalFixedExpenses();

  double get freeBudget => Budget(income: income, fixedExpenses: fixedExpenses, variableExpenses: variableExpenses).freeBudget();

  double get totalSpent => Budget(income: income, fixedExpenses: fixedExpenses, variableExpenses: variableExpenses).totalSpent();

  double get currentAvailable => freeBudget - totalSpent;

  double get percentageSpent => Budget(income: income, fixedExpenses: fixedExpenses, variableExpenses: variableExpenses).percentageSpent();

  LuccyStatus getLuccyStatus() => Budget(income: income, fixedExpenses: fixedExpenses, variableExpenses: variableExpenses).getStatus();

  // --- Actions ---
  void submitAuth({String? name}) {
    if (authState == AuthState.register && (name ?? '').trim().isNotEmpty) {
      userName = name!;
      authState = AuthState.authenticated;
      setupState = SetupState.inProgress;
    } else if (authState == AuthState.login) {
      userName = 'Usuario';
      authState = AuthState.authenticated;
      setupState = income == 0.0 ? SetupState.inProgress : SetupState.completed;
    }
    notifyListeners();
  }

  void setAuthState(AuthState s) {
    authState = s;
    notifyListeners();
  }

  void setSetupState(SetupState s) {
    setupState = s;
    notifyListeners();
  }

  void setActiveTab(String tab) {
    activeTab = tab;
    notifyListeners();
  }

  void setIncome(double value) {
    income = value;
    notifyListeners();
  }

  void addFixedExpense(String desc, double amount) {
    fixedExpenses.add(FixedExpense(id: DateTime.now().millisecondsSinceEpoch, description: desc, amount: amount));
    notifyListeners();
  }

  void removeFixedExpense(int id) {
    fixedExpenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void finishSetup() {
    if (income > 0) setupState = SetupState.completed;
    notifyListeners();
  }

  Future<void> addVariableExpense(double amount, String desc) async {
    final e = VariableExpense(
      id: DateTime.now().millisecondsSinceEpoch,
      amount: amount,
      description: desc,
      date: DateTime.now().toIso8601String(),
    );
    final uc = AddExpense(repository);
    await uc.call(e);
    // keep local cache in sync
    variableExpenses.insert(0, e);
    notifyListeners();
  }

  String formatCurrency(double val) {
    return NumberFormat.simpleCurrency(locale: 'es_ES', name: 'USD').format(val);
  }
}
