import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/models/services_model.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:esae_monie/presentation/widgets/giftsuccessful_bottom_sheet.dart';
import 'package:esae_monie/presentation/widgets/text_title.dart';
import 'package:flutter/material.dart';

class GiftTransactionSuccessful extends StatelessWidget {
  static const String routeName = 'GiftTransactionSuccessful';
  const GiftTransactionSuccessful({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final ServicesModel service = args['service'];
    final String accountName = args['name'];
    final String accountNumber = args['accountNumber'];
    final double amountDouble = args['amount'];
    final String imagePath = args['imagePath'];

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
                  TextTitle(
                    text: 'Transaction successful',
                    color: AppColors.blackColor,
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
                  AppSpacing.verticalSpaceMassive,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/success.png',
                      width: double.infinity,
                      height: screenHeight * 0.35,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.1),
                  Button(
                    'View Receipts',
                    color: AppColors.blueColor,
                    onPressed: () {
                      print('Button pressed!');
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useRootNavigator: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        builder: (_) => GiftSuccessBottomSheet(
                          amount: amountDouble,
                          accountName: accountName,
                          accountNumber: accountNumber,
                          imagePath: imagePath,
                          giftTitle: service.title,
                        ),
                      );
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
