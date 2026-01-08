import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/text_title.dart';
import 'package:flutter/material.dart';

class GiftSuccessBottomSheet extends StatelessWidget {
  final double amount;
  final String accountName;
  final String accountNumber;
  final String imagePath;
  final String giftTitle;

  const GiftSuccessBottomSheet({
    super.key,
    required this.amount,
    required this.accountName,
    required this.accountNumber,
    required this.imagePath,
    required this.giftTitle,
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
                      TextTitle(text: giftTitle),
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
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade800,
                              ),
                        ),
                        backgroundColor: Colors.green.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.transparent),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
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
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      imagePath,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),

          AppSpacing.verticalSpaceLarge,

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Button(
              'Done',
              color: AppColors.blueColor,
              onPressed: () {
                Navigator.pop(context); // closes bottom sheet only
              },
            ),
          ),
        ],
      ),
    );
  }
}
