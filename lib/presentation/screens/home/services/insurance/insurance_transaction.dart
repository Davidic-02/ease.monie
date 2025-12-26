import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/models/insurance_model.dart';
import 'package:esae_monie/models/services_model.dart';
import 'package:esae_monie/presentation/screens/home/services/insurance/insurance_transaction_successful.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class InsuranceTransaction extends HookWidget {
  static const String routeName = 'InsuranceTransaction';
  const InsuranceTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Get arguments from previous screen
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final ServicesModel services = args['service'];
    final InsuranceModel selectedInsurance = args['insurance'];
    final String paymentPlan = args['paymentPlan'];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
          child: SingleChildScrollView(
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

                            // Service / Account Name
                            Text(
                              services.title,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            AppSpacing.verticalSpaceMedium,

                            // Organizer / Account Number
                            Text(
                              services.organizer,
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

                            // Payment Amount (use paymentPlan as amount)
                            RichText(
                              text: TextSpan(
                                text: paymentPlan,
                                style: Theme.of(context).textTheme.titleMedium,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Card Type",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  "Debit Card",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),

                            const Divider(height: 30),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Transfer Fee",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  "$paymentPlan USD",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  "$paymentPlan USD",
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Service Image
                    Positioned(
                      top: -40,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.asset(
                            services.imagePath,
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
                    vertical: 24,
                    horizontal: 40,
                  ),
                  child: Button(
                    color: AppColors.blueColor,
                    'Send Money',
                    onPressed: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        InsuranceTransactionSuccessful.routeName,
                        arguments: {
                          'paymentType': paymentPlan,
                          'service': services,
                          'name': services.title,
                          'accountNumber': services.organizer,
                          'amount': paymentPlan,
                          'imagePath': services.imagePath,
                        },
                      );

                      if (result != null) {
                        Navigator.pop(context, result);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
