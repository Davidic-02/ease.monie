class ScheduledPayment {
  final String image;
  final String name;
  final double amount; // ✅ now double
  final String dueDate;

  ScheduledPayment({
    required this.image,
    required this.name,
    required this.amount,
    required this.dueDate,
  });
}

class RecentTransfer {
  final String image;
  final String name;
  final String amount;

  RecentTransfer({
    required this.image,
    required this.name,
    required this.amount,
  });
}
