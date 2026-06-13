// Models for expenses and status
class FixedExpense {
  final int id;
  final String description;
  final double amount;

  FixedExpense({
    required this.id,
    required this.description,
    required this.amount,
  });
}

class VariableExpense {
  final int id;
  final double amount;
  final String description;
  final String date;

  VariableExpense({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
  });
}

class LuccyStatus {
  final String message;
  final StatusLevel level;

  LuccyStatus({required this.message, required this.level});
}

enum StatusLevel { healthy, attention, danger, critical }
