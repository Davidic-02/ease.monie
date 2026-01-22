import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/data/lists.dart';
import 'package:esae_monie/presentation/screens/home/services/loan/loan_helper.dart';
import 'package:esae_monie/presentation/screens/home/services/loan/loan_payment_plans.dart';
import 'package:esae_monie/presentation/widgets/custom_topbar.dart';
import 'package:esae_monie/presentation/widgets/custom_vertical_scrolls.dart';
import 'package:esae_monie/presentation/widgets/loan_card.dart';
import 'package:esae_monie/presentation/widgets/text_child.dart';
import 'package:esae_monie/presentation/widgets/text_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/svg.dart';

class Loan extends HookWidget {
  static const String routeName = 'Loan';
  const Loan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomTopbar(
                title: 'Loan',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppSpacing.verticalSpaceHuge,
                    TextChild(text: 'Car Loan'),
                    TextTitle(text: '₦$totalAmount'),
                    SizedBox(
                      height: 220,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              sections: buildLoanSections(loanModel),
                              centerSpaceRadius: 40,
                              sectionsSpace: 2,
                            ),
                          ),

                          TextTitle(text: '50%'),
                        ],
                      ),
                    ),

                    AppSpacing.verticalSpaceMedium,

                    Row(
                      children: [
                        Expanded(
                          child: LoanCard(
                            color: Colors.green,
                            title: 'Paid',
                            amount: '₦120k',
                          ),
                        ),
                        AppSpacing.horizontalSpaceSmall,
                        Expanded(
                          child: LoanCard(
                            color: Colors.red,
                            title: 'Due',
                            amount: '₦80k',
                          ),
                        ),
                        AppSpacing.horizontalSpaceSmall,
                        Expanded(
                          child: LoanCard(
                            color: Colors.orange,
                            title: 'Processing',
                            amount: '₦40k',
                          ),
                        ),
                      ],
                    ),

                    AppSpacing.verticalSpaceMassive,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextTitle(text: 'Recommended Loans'),
                    ),
                    AppSpacing.verticalSpaceMedium,

                    CustomVerticalscrolls(
                      itemCount: recommendedLoan.length,
                      itemBuilder: (index) {
                        final loan = recommendedLoan[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Material(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context).colorScheme.surface,
                            child: Container(
                              padding: const EdgeInsets.all(16),

                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    loan.image,
                                    width: 40,
                                    height: 40,
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          loan.title,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '₦${loan.amount.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        LoanPaymentPlans.routeName,
                                        arguments: loan,
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'Apply',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
