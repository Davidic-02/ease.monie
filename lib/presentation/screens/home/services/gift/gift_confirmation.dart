import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/models/gift_model.dart';
import 'package:esae_monie/models/services_model.dart';
import 'package:esae_monie/presentation/screens/home/services/gift/gift_transaction_successful.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:esae_monie/presentation/widgets/text_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GiftConfirmation extends HookWidget {
  static const String routeName = 'GiftConfirmation';
  const GiftConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final GiftPayload payload =
        ModalRoute.of(context)!.settings.arguments as GiftPayload;

    final ServicesModel myService = payload.service;
    final String accountName = payload.name;
    final String accountNumber = payload.accountNumber;
    final double amountDouble = payload.amount;
    final String imagePath = myService.imagePath;

    final String amount = amountDouble.toStringAsFixed(2);

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
                    'Are You Sure ?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.blueColor.shade300,
                      fontSize: 25,
                    ),
                  ),

                  AppSpacing.verticalSpaceMedium,
                  Padding(
                    padding: EdgeInsets.symmetric(
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

                              TextTitle(text: myService.title),

                              Text(
                                accountName,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              AppSpacing.verticalSpaceMedium,

                              Text(
                                accountNumber,
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
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Image.asset(
                              imagePath,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.1),
                  Button(
                    color: AppColors.blueColor,
                    'Send Money',
                    onPressed: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        GiftTransactionSuccessful.routeName,
                        arguments: {
                          'service': myService, // your ServicesModel instance
                          'name': accountName,
                          'accountNumber': accountNumber,
                          'amount': amountDouble,
                          'imagePath': imagePath,
                        },
                      );

                      if (result != null) {
                        Navigator.pop(context, result);
                      }
                    },
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
