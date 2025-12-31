import 'package:esae_monie/blocs/loan/loan_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/data/formatter.dart';
import 'package:esae_monie/presentation/screens/home/services/loan/loan_transaction_successful.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_topbar.dart';
import 'package:esae_monie/presentation/widgets/text_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoanPaymentConfirmation extends HookWidget {
  static const String routeName = 'LoanPaymentConfirmation';
  const LoanPaymentConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final loanAmount = formatter.format(args['principal'] ?? 0);
    final interest = formatter.format(args['Interest'] ?? 0);
    final totalPayment = formatter.format(args['totalPayment'] ?? 0);
    final dueDate = args['dueDate'] ?? '';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomTopbar(
                title: 'Payment Plan',
                onTap: () => Navigator.pop(context),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing.verticalSpaceMassive,

                    TextTitle(text: 'Reckoning'),
                    AppSpacing.verticalSpaceSmall,
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Loan Amount',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  loanAmount,
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Interest',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  interest,
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Due Date',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  dueDate,
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Total Payable',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  totalPayment,
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    TextTitle(text: 'Upcoming Payment'),

                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.02),

                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Due Date',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  dueDate,
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Total Payable',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  totalPayment,
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),

                          BlocBuilder<LoanBloc, LoanState>(
                            builder: (context, state) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),

                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Auto Payment',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Automatically pay on due date',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Switch(
                                      value: state.autoPayment,
                                      onChanged: (value) {
                                        context.read<LoanBloc>().add(
                                          LoanEvent.autoPaymentToggled(value),
                                        );
                                      },
                                      activeThumbColor: Colors.white,
                                      activeTrackColor: Colors.blue,
                                      inactiveThumbColor: Colors.grey,
                                      inactiveTrackColor: Colors.white54,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.05),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 40,
                      ),
                      child: Button(
                        color: AppColors.blueColor,
                        'Continue',
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            LoanTransactionSuccessful.routeName,
                            arguments: {},
                          );
                        },
                      ),
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
