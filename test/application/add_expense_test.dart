import 'package:flutter_test/flutter_test.dart';
import 'package:luccy/src/application/add_expense.dart';
import 'package:luccy/src/infra/in_memory_expense_repository.dart';
import 'package:luccy/src/models/expense.dart';

void main() {
  test('AddExpense use-case stores expense in repository', () async {
    final repo = InMemoryExpenseRepository();
    final uc = AddExpense(repo);
    final expense = VariableExpense(id: 1, amount: 12.5, description: 'test', date: DateTime.now().toIso8601String());
    await uc.call(expense);
    final list = await repo.getExpenses();
    expect(list.length, 1);
    expect(list.first.amount, 12.5);
  });
}
