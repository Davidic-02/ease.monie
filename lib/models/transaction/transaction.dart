class Transaction {
  final String id;
  final String name;
  final String icon;
  final double amount;
  final DateTime date;
  final String category;

  Transaction({
    required this.id,
    required this.name,
    required this.icon,
    required this.amount,
    required this.date,
    required this.category,
  });
}

class DailyBalance {
  final DateTime date;
  final double balance;

  DailyBalance({required this.date, required this.balance});
}

class FinanceSummary {
  final double totalBalance;
  final double moneyIn;
  final double moneyOut;
  final List<DailyBalance> dailyBalances;
  final List<Transaction> recentTransactions;

  FinanceSummary({
    required this.totalBalance,
    required this.moneyIn,
    required this.moneyOut,
    required this.dailyBalances,
    required this.recentTransactions,
  });
}
