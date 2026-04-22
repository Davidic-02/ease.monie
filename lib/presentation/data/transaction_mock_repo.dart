// lib/repository/fintech_mock_repository.dart

import 'package:esae_monie/models/transaction/transaction.dart';

class FintechMockRepository {
  static FinanceSummary getMockFinanceSummary() {
    return FinanceSummary(
      totalBalance: 4228.76,
      moneyIn: 271.00,
      moneyOut: 180.00,
      dailyBalances: [
        DailyBalance(date: DateTime(2024, 11, 10), balance: 3800.00),
        DailyBalance(date: DateTime(2024, 11, 15), balance: 3900.00),
        DailyBalance(date: DateTime(2024, 11, 20), balance: 4100.00),
        DailyBalance(date: DateTime(2024, 11, 25), balance: 4000.00),
        DailyBalance(date: DateTime(2024, 11, 30), balance: 4228.76),
      ],
      recentTransactions: [
        Transaction(
          id: '1',
          name: 'Dropbox',
          icon: '📦',
          amount: 10.00,
          date: DateTime(2024, 11, 30, 14, 30),
          category: 'Subscription',
        ),
        Transaction(
          id: '2',
          name: 'Apple Pay',
          icon: '🍎',
          amount: 8.50,
          date: DateTime(2024, 11, 30, 10, 15),
          category: 'Payment',
        ),
        Transaction(
          id: '3',
          name: 'LinkedIn',
          icon: '💼',
          amount: 5.00,
          date: DateTime(2024, 11, 29, 16, 45),
          category: 'Subscription',
        ),
      ],
    );
  }
}
