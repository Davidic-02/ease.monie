import 'package:esae_monie/blocs/recharge/recharge_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:esae_monie/presentation/widgets/giftsuccessful_bottom_sheet.dart';
import 'package:esae_monie/presentation/widgets/text_child.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RechargeTransactionSuccessful extends StatelessWidget {
  static const String routeName = 'RechargeTransactionSuccessful';
  const RechargeTransactionSuccessful({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<RechargeBloc, RechargeState>(
      builder: (context, state) {
        final amount = double.tryParse(state.amount.value) ?? 0;
        final accountName = state.selectedNetwork?.name ?? '';
        final accountNumber = state.phoneNumber.value;
        final imagePath = state.selectedNetwork?.image ?? '';
        final giftTitle = state.selectedNetwork?.name ?? '';

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 20,
              ),
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
                        width: screenWidth * 0.8,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.asset(
                            'assets/images/success.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.1),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 24,
                      ),
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
                              amount: amount,
                              accountName: accountName,
                              accountNumber: accountNumber,
                              imagePath: imagePath,
                              giftTitle: giftTitle,
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
      },
    );
  }
}
