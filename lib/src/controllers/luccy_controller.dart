import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';

enum AuthState { login, register, authenticated }
enum SetupState { notStarted, inProgress, completed }

class LuccyController extends ChangeNotifier {
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
  double get totalFixedExpenses =>
      fixedExpenses.fold(0.0, (sum, item) => sum + item.amount);

  double get freeBudget => income - totalFixedExpenses;

  double get totalSpent =>
      variableExpenses.fold(0.0, (sum, item) => sum + item.amount);

  double get currentAvailable => freeBudget - totalSpent;

  double get percentageSpent => freeBudget > 0 ? (totalSpent / freeBudget) * 100 : 0;

  LuccyStatus getLuccyStatus() {
    final p = percentageSpent;
    if (p >= 100) {
      return LuccyStatus(
          message:
              '¡ALERTA CRÍTICA! Has superado tu límite mensual. Detén los gastos no esenciales inmediatamente.',
          level: StatusLevel.critical);
    } else if (p >= 80) {
      return LuccyStatus(
          message:
              '¡Peligro! Te queda muy poco presupuesto. Tienes un alto riesgo financiero este mes.',
          level: StatusLevel.danger);
    } else if (p >= 50) {
      return LuccyStatus(
          message:
              'Atención: Has gastado más de la mitad de tu presupuesto libre. Modera tus próximos gastos.',
          level: StatusLevel.attention);
    } else {
      return LuccyStatus(
          message: '¡Vas por excelente camino! Tus finanzas están bajo control y saludables.',
          level: StatusLevel.healthy);
    }
  }

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

  void addVariableExpense(double amount, String desc) {
    final e = VariableExpense(
      id: DateTime.now().millisecondsSinceEpoch,
      amount: amount,
      description: desc,
      date: DateTime.now().toIso8601String(),
    );
    variableExpenses.insert(0, e);
    notifyListeners();
  }

  String formatCurrency(double val) {
    return NumberFormat.simpleCurrency(locale: 'es_ES', name: 'USD').format(val);
  }
}
