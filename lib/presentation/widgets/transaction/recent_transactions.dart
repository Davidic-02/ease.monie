// lib/presentation/widgets/fintech/recent_transactions.dart
import 'package:esae_monie/models/transaction/transaction.dart';
import 'package:esae_monie/presentation/widgets/transaction/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:esae_monie/constants/app_spacing.dart';

class RecentTransactions extends StatelessWidget {
  final List<Transaction> transactions;

  const RecentTransactions({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Recent Transactions',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        AppSpacing.verticalSpaceSmall,
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            return TransactionItem(transaction: transactions[index]);
          },
        ),
      ],
    );
  }
}
