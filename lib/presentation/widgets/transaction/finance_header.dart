import 'package:flutter/material.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';

class FintechHeader extends StatelessWidget {
  final double totalBalance;

  const FintechHeader({super.key, required this.totalBalance});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTopbar(title: 'Fintech'),

          const SizedBox(height: 20),

          Text(
            'Total Balance',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.greyColor,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '\$${totalBalance.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 32,
              color: AppColors.blueColor,
            ),
          ),
        ],
      ),
    );
  }
}
