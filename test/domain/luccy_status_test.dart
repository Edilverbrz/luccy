import 'package:flutter_test/flutter_test.dart';
import 'package:luccy/src/domain/budget.dart';
import 'package:luccy/src/models/expense.dart';

void main() {
  test('Budget status is healthy when percentage < 50', () {
    final budget = Budget(income: 1000.0, fixedExpenses: [FixedExpense(id:1, description:'a', amount:100.0)], variableExpenses: [VariableExpense(id:1, amount:10.0, description:'x', date:DateTime.now().toIso8601String())]);
    final status = budget.getStatus();
    expect(status.level, StatusLevel.healthy);
  });

  test('Budget status is attention when percentage between 50 and <80', () {
    // freeBudget = income - fixed = 1000 - 100 = 900; totalSpent set to make percentage ~60
    final budget = Budget(income: 1000.0, fixedExpenses: [FixedExpense(id:1, description:'a', amount:100.0)], variableExpenses: [VariableExpense(id:1, amount:540.0, description:'x', date:DateTime.now().toIso8601String())]);
    final status = budget.getStatus();
    expect(status.level, StatusLevel.attention);
  });

  test('Budget status is danger when percentage between 80 and <100', () {
    final budget = Budget(income: 1000.0, fixedExpenses: [FixedExpense(id:1, description:'a', amount:100.0)], variableExpenses: [VariableExpense(id:1, amount:800.0, description:'x', date:DateTime.now().toIso8601String())]);
    final status = budget.getStatus();
    expect(status.level, StatusLevel.danger);
  });

  test('Budget status is critical when percentage >= 100', () {
    final budget = Budget(income: 1000.0, fixedExpenses: [FixedExpense(id:1, description:'a', amount:100.0)], variableExpenses: [VariableExpense(id:1, amount:1000.0, description:'x', date:DateTime.now().toIso8601String())]);
    final status = budget.getStatus();
    expect(status.level, StatusLevel.critical);
  });
}
