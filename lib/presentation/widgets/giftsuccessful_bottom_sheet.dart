import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:flutter/material.dart';

class GiftSuccessBottomSheet extends StatelessWidget {
  final double amount;
  final String accountName;
  final String accountNumber;
  final String imagePath;

  const GiftSuccessBottomSheet({
    super.key,
    required this.amount,
    required this.accountName,
    required this.accountNumber,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          AppSpacing.verticalSpaceLarge,

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
                    children: [
                      AppSpacing.verticalSpaceLarge,

                      Text(
                        accountName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),

                      AppSpacing.verticalSpaceSmall,

                      Text(
                        accountNumber,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                      AppSpacing.verticalSpaceSmall,

                      Chip(
                        label: Text(
                          'Transaction Status: Successful',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                      ),

                      AppSpacing.verticalSpaceMedium,

                      RichText(
                        text: TextSpan(
                          text: amount.toStringAsFixed(2),
                          style: Theme.of(context).textTheme.titleMedium,
                          children: const [TextSpan(text: ' USD')],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: -35,
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      imagePath,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),

          AppSpacing.verticalSpaceLarge,

          Button(
            'Done',
            color: AppColors.blueColor,
            onPressed: () {
              Navigator.pop(context); // closes bottom sheet only
            },
          ),
        ],
      ),
    );
  }
}
