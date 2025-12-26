import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/data/lists.dart';
import 'package:esae_monie/presentation/screens/home/services/charity/donation.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:esae_monie/presentation/widgets/services_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Charity extends HookWidget {
  static const String routeName = 'Charity';
  const Charity({super.key});

  @override
  Widget build(BuildContext context) {
    final deadline = DateTime.now().add(const Duration(days: 7));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomTopbar(
                title: 'Charity',
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
                      service: charity1.value,
                      deadlineDate: deadline,
                      onButtonPressed: () async {
                        final updatedAmount = await Navigator.pushNamed(
                          context,
                          Donation.routeName,
                          arguments: charity1.value,
                        );
                        if (updatedAmount != null && updatedAmount is double) {
                          charity1.value = charity1.value.copyWith(
                            donatedAmount:
                                charity1.value.donatedAmount + updatedAmount,
                          );
                        }
                      },
                      showProgressBar: true,
                      showPercentageBadge: true,
                      buttonText: 'Donate',
                    ),
                    AppSpacing.verticalSpaceHuge,
                    ServiceCard(
                      service: charity2.value,
                      showProgressBar: true,
                      deadlineDate: deadline,
                      showPercentageBadge: true,
                      onButtonPressed: () async {
                        final updatedAmount = await Navigator.pushNamed(
                          context,
                          Donation.routeName,
                          arguments: charity2.value,
                        );
                        if (updatedAmount != null && updatedAmount is double) {
                          charity2.value = charity2.value.copyWith(
                            donatedAmount:
                                charity2.value.donatedAmount + updatedAmount,
                          );
                        }
                      },
                    ),

                    AppSpacing.verticalSpaceMedium,

                    ServiceCard(
                      service: charity1.value,
                      deadlineDate: deadline,
                      showProgressBar: true,
                      showPercentageBadge: true,
                      onButtonPressed: () async {
                        final updatedAmount = await Navigator.pushNamed(
                          context,
                          Donation.routeName,
                          arguments: charity1.value,
                        );
                        if (updatedAmount != null && updatedAmount is double) {
                          charity1.value = charity1.value.copyWith(
                            donatedAmount:
                                charity1.value.donatedAmount + updatedAmount,
                          );
                        }
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
