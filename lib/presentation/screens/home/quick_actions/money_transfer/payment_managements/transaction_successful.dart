import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionSuccessful extends StatelessWidget {
  static const String routeName = 'TransactionSuccessful';
  const TransactionSuccessful({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    'Are you sure?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
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
                  Button('View Receipts', onPressed: () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
