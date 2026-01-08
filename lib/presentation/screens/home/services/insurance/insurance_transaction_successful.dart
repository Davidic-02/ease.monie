import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/models/services_model.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:esae_monie/presentation/widgets/giftsuccessful_bottom_sheet.dart';
import 'package:esae_monie/presentation/widgets/text_child.dart';
import 'package:flutter/material.dart';

class InsuranceTransactionSuccessful extends StatelessWidget {
  static const String routeName = 'InsuranceTransactionSuccessful';
  const InsuranceTransactionSuccessful({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final ServicesModel service = args['service'];
    final String paymentType = args['paymentType'] ?? 'Unknown';
    final String accountNumber = args['accountNumber'];
    final double amountDouble =
        double.tryParse(args['amount'].toString()) ?? 0.0;
    final String imagePath = args['imagePath'];

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
                      'We care about your privacy. Please make sure you want to transfer money',
                ),
                AppSpacing.verticalSpaceMassive,
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: screenWidth * 0.8, // 80% of screen width
                    child: AspectRatio(
                      aspectRatio:
                          1, // keep it square, or use real ratio of the image
                      child: Image.asset(
                        'assets/images/success.png',
                        fit: BoxFit
                            .contain, 
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.1),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                  child: Button(
                    'View Receipts',
                    color: AppColors.blueColor,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: false,
                        useRootNavigator: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (_) => GiftSuccessBottomSheet(
                          amount: amountDouble,
                          accountName: paymentType,
                          accountNumber: accountNumber,
                          imagePath: imagePath,
                          giftTitle: service.title,
                        ),
                      );
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
