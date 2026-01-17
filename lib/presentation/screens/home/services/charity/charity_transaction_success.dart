import 'package:esae_monie/blocs/charity/charity_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/screens/home/services/charity/charity.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:esae_monie/presentation/widgets/giftsuccessful_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharityTransactionSuccess extends StatelessWidget {
  static const String routeName = 'CharityTransactionSuccess';
  const CharityTransactionSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CharityBloc>().state;
    final charityId = state.selectedCharityId;

    // If no charity is selected
    if (charityId == null) {
      return const Scaffold(body: Center(child: Text('No charity selected.')));
    }

    final currentCharity = state.charities[charityId];
    if (currentCharity == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final amountDouble = double.tryParse(state.donationAmount.value) ?? 0.0;
    final amount = amountDouble.toStringAsFixed(2);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
                    onTap: () => Navigator.pop(context),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      'We care about your privacy. Please keep this transaction safe.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  AppSpacing.verticalSpaceMassive,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: screenWidth * 0.8,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.asset(
                          currentCharity.imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.1),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 40,
                    ),
                    child: Button(
                      'View Receipts',
                      color: AppColors.blueColor,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useRootNavigator: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          builder: (_) => GiftSuccessBottomSheet(
                            amount: amountDouble,
                            accountName: currentCharity.organizer,
                            accountNumber: currentCharity.id,
                            imagePath: currentCharity.imagePath,
                            giftTitle: currentCharity.organizer,
                          ),
                        );

                        context.read<CharityBloc>().add(
                          CharityEvent.donationAmountChanged(''),
                        );
                        Navigator.popUntil(
                          context,
                          ModalRoute.withName(Charity.routeName),
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
