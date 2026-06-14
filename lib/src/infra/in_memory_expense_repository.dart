import '../../src/domain/expense_repository.dart';
import '../../src/models/expense.dart';

class InMemoryExpenseRepository implements ExpenseRepository {
  final List<VariableExpense> _store = [];

  @override
  Future<void> addExpense(VariableExpense expense) async {
    _store.insert(0, expense);
  }

  @override
  Future<List<VariableExpense>> getExpenses() async {
    return List.unmodifiable(_store);
  }
}
