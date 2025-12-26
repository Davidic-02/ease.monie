import 'package:esae_monie/constants/app_spacing.dart';

import 'package:esae_monie/presentation/data/lists.dart';
import 'package:esae_monie/presentation/screens/home/services/insurance/type_of_insurance.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:esae_monie/presentation/widgets/services_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Insurance extends HookWidget {
  static const String routeName = 'Insurance';
  const Insurance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomTopbar(
                title: 'Insurance',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing.verticalSpaceHuge,

                    ServiceCard(
                      service: insurance1.value,
                      deadlineDate: familyOfferDeadline,
                      showProgressBar: false,
                      showPercentageBadge: false,
                      buttonText: 'Send',
                      bottomLeftText: '🎁 Get 10% Cashback',
                      onButtonPressed: () {
                        Navigator.pushNamed(
                          context,
                          TypeOfInsurance.routeName,
                          arguments: insurance1.value,
                        );
                      },
                    ),
                    AppSpacing.verticalSpaceMedium,
                    ServiceCard(
                      service: insurance2.value,
                      deadlineDate: houseOfferDeadline,
                      showProgressBar: false,
                      showPercentageBadge: false,
                      buttonText: 'Send',
                      bottomLeftText: '🎁 Get 10% Cashback',
                      onButtonPressed: () {
                        Navigator.pushNamed(
                          context,
                          TypeOfInsurance.routeName,
                          arguments: insurance2.value,
                        );
                      },
                    ),
                    AppSpacing.verticalSpaceMedium,
                    ServiceCard(
                      service: insurance3.value,
                      deadlineDate: houseOfferDeadline,
                      showProgressBar: false,
                      showPercentageBadge: false,
                      buttonText: 'Send',
                      bottomLeftText: '🎁 Get 10% Cashback',
                      onButtonPressed: () {
                        Navigator.pushNamed(
                          context,
                          TypeOfInsurance.routeName,
                          arguments: insurance3.value,
                        );
                      },
                    ),
                    AppSpacing.verticalSpaceMedium,
                    ServiceCard(
                      service: insurance2.value,
                      deadlineDate: familyOfferDeadline,
                      showProgressBar: false,
                      showPercentageBadge: false,
                      buttonText: 'Send',
                      bottomLeftText: '🎁 Get 10% Cashback',
                      onButtonPressed: () {
                        Navigator.pushNamed(
                          context,
                          TypeOfInsurance.routeName,
                          arguments: insurance2.value,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
