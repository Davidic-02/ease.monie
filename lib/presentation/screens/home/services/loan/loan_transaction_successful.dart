import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:esae_monie/presentation/widgets/text_child.dart';
import 'package:flutter/material.dart';

class LoanTransactionSuccessful extends StatelessWidget {
  static const String routeName = 'LoanTransactionSuccessful';
  const LoanTransactionSuccessful({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
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
                  'Transaction Successful!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.blueColor.shade300,
                    fontSize: 25,
                  ),
                ),

                AppSpacing.verticalSpaceMedium,
                TextChild(
                  text:
                      'Your Loan Request is Accepted. you will get the loan soon',
                ),
                AppSpacing.verticalSpaceMassive,
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: screenWidth * 0.8,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        'assets/images/loan_success.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.1),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                  child: Button(
                    'View Breakdown',
                    color: AppColors.blueColor,
                    onPressed: () {},
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
