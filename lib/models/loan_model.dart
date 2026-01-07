class LoanModel {
  final String title;
  final double amount;

  LoanModel({required this.title, required this.amount});
}

class RecommendedLoan {
  final String title;
  final String image;
  final double amount;

  const RecommendedLoan({
    required this.title,
    required this.image,
    required this.amount,
  });
}
