import '../models/expense.dart';

class Budget {
  final double income;
  final List<FixedExpense> fixedExpenses;
  final List<VariableExpense> variableExpenses;

  Budget({required this.income, required this.fixedExpenses, required this.variableExpenses});

  double totalFixedExpenses() => fixedExpenses.fold(0.0, (sum, item) => sum + item.amount);

  double freeBudget() => income - totalFixedExpenses();

  double totalSpent() => variableExpenses.fold(0.0, (sum, item) => sum + item.amount);

  double percentageSpent() {
    final fb = freeBudget();
    return fb > 0 ? (totalSpent() / fb) * 100 : 0;
  }

  LuccyStatus getStatus() {
    final p = percentageSpent();
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
}
