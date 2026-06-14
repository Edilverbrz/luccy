import '../domain/expense_repository.dart';
import '../models/expense.dart';

class AddExpense {
  final ExpenseRepository repository;
  AddExpense(this.repository);

  Future<void> call(VariableExpense expense) async {
    // simple validation could go here
    if (expense.amount <= 0) throw ArgumentError('Amount must be positive');
    await repository.addExpense(expense);
  }
}
