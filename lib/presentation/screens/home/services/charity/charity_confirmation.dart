import 'package:esae_monie/blocs/charity/charity_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/screens/home/services/charity/charity_transaction_success.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharityConfirmation extends StatelessWidget {
  static const String routeName = 'CharityConfirmation';
  const CharityConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CharityBloc>().state;
    final charityId = state.selectedCharityId;

    // Handle no selected charity
    if (charityId == null) {
      return const Scaffold(body: Center(child: Text('No charity selected.')));
    }

    final currentCharity = state.charities[charityId];
    if (currentCharity == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Get donation amount from Bloc
    final amountDouble = double.tryParse(state.donationAmount.value) ?? 0.0;
    final amount = amountDouble.toStringAsFixed(2);

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTopbar(
                    title: 'Confirmation',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  AppSpacing.verticalSpaceMassive,
                  Text(
                    'Are You Sure?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.blueColor.shade300,
                      fontSize: 25,
                    ),
                  ),
                  AppSpacing.verticalSpaceMedium,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 25,
                    ),
                    child: Text(
                      'We care about your privacy. Please make sure you want to transfer money.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.07),
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppSpacing.verticalSpaceMassive,
                              Text(
                                currentCharity.organizer, // Use Bloc data
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              AppSpacing.verticalSpaceMedium,
                              Text(
                                currentCharity.id,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Chip(
                                label: Text(
                                  'Transaction Status: Pending',
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.errorContainer,
                                labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                              const SizedBox(height: 20),
                              RichText(
                                text: TextSpan(
                                  text: amount,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                  children: [
                                    TextSpan(
                                      text: ' USD',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Card Type",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  Text(
                                    "Debit Card",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              const Divider(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Transfer Fee",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  Text(
                                    "$amount USD",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  Text(
                                    "$amount USD",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: -40,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Image.asset(
                              currentCharity.imagePath,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.1),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 40,
                    ),
                    child: Button(
                      color: AppColors.blueColor,
                      'Send Money',
                      onPressed: () {
                        final bloc = context.read<CharityBloc>();
                        bloc.add(
                          CharityEvent.donationCompleted(
                            charityId: charityId,
                            donatedAmount: amountDouble,
                          ),
                        );

                        Navigator.pushNamed(
                          context,
                          CharityTransactionSuccess.routeName,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
