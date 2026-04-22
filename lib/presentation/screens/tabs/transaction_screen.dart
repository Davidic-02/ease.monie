import 'package:esae_monie/presentation/data/transaction_mock_repo.dart';
import 'package:esae_monie/presentation/widgets/transaction/finance_chart.dart';
import 'package:esae_monie/presentation/widgets/transaction/finance_header.dart';
import 'package:esae_monie/presentation/widgets/transaction/recent_transactions.dart';
import 'package:esae_monie/presentation/widgets/transaction/summary_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:esae_monie/constants/app_spacing.dart';

class TransactionScreen extends HookWidget {
  const TransactionScreen({super.key});

  static const String routeName = 'transaction_screen';

  @override
  Widget build(BuildContext context) {
    final financeSummary = FintechMockRepository.getMockFinanceSummary();

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              FintechHeader(totalBalance: financeSummary.totalBalance),

              AppSpacing.verticalSpaceSmall,

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FinanceChart(
                  dailyBalances: financeSummary.dailyBalances,
                ),
              ),

              AppSpacing.verticalSpaceLarge,

              FinanceSummaryCards(
                moneyIn: financeSummary.moneyIn,
                moneyOut: financeSummary.moneyOut,
              ),

              AppSpacing.verticalSpaceLarge,

              RecentTransactions(
                transactions: financeSummary.recentTransactions,
              ),

              AppSpacing.verticalSpaceLarge,
            ],
          ),
        ),
      ),
    );
  }
}
