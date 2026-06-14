import '../models/expense.dart';

abstract class ExpenseRepository {
  Future<List<VariableExpense>> getExpenses();
  Future<void> addExpense(VariableExpense expense);
}
