import 'package:esae_monie/blocs/gift/gift_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:esae_monie/presentation/widgets/giftsuccessful_bottom_sheet.dart';
import 'package:esae_monie/presentation/widgets/text_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GiftTransactionSuccessful extends StatelessWidget {
  static const String routeName = 'GiftTransactionSuccessful';
  const GiftTransactionSuccessful({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GiftBloc>().state;
    final selectedGiftId = state.selectedGiftId;

    if (selectedGiftId == null) {
      return const Scaffold(body: Center(child: Text('No gift selected.')));
    }

    final giftIndex = state.giftModel.indexWhere(
      (gift) => gift.id == selectedGiftId,
    );

    if (giftIndex == -1) {
      return const Scaffold(body: Center(child: Text('Gift not found.')));
    }
    final currentGift = state.giftModel[giftIndex];

    final accountName = state.recipientName.value;
    final accountNumber = state.accountNumber.value;
    final amountDouble = double.tryParse(state.amount.value) ?? 0.0;

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
                          imagePath: currentGift.imagePath,
                          giftTitle: currentGift.title,
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
