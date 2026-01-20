import 'package:esae_monie/blocs/charity/charity_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/screens/home/services/charity/charity.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:esae_monie/presentation/widgets/giftsuccessful_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharityTransactionSuccess extends HookWidget {
  static const String routeName = 'CharityTransactionSuccess';

  const CharityTransactionSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CharityBloc>().state;
    final charityId = state.selectedCharityId;

    // useState hooks to capture amount & charityId
    final capturedAmount = useState<double?>(null);
    final capturedCharityId = useState<String?>(null);

    // Capture the donation amount once after first build
    useEffect(() {
      if (charityId != null && capturedAmount.value == null) {
        final currentDonationAmount = state.donationAmounts[charityId];
        final amountDouble =
            double.tryParse(currentDonationAmount?.value ?? '') ?? 0.0;

        capturedAmount.value = amountDouble;
        capturedCharityId.value = charityId;

        // Complete the donation (update charity's raised amount)
        if (amountDouble > 0) {
          context.read<CharityBloc>().add(
            CharityEvent.donationCompleted(
              charityId: charityId,
              donatedAmount: amountDouble,
            ),
          );
        }
      }
      return null;
    }, [charityId, state.donationAmounts]);

    final currentCharity = charityId != null
        ? state.charities[charityId]
        : null;

    if (charityId == null || currentCharity == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Use captured amount if available
    final amountDouble =
        capturedAmount.value ??
        (double.tryParse(state.donationAmounts[charityId]?.value ?? '') ?? 0.0);

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
                      onPressed: () async {
                        await showModalBottomSheet(
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

                        // Clear donation amount and navigate back
                        if (context.mounted) {
                          context.read<CharityBloc>().add(
                            CharityEvent.donationAmountChanged(''),
                          );

                          Navigator.of(context).pushNamedAndRemoveUntil(
                            Charity.routeName,
                            (route) => route.isFirst,
                          );
                        }
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
