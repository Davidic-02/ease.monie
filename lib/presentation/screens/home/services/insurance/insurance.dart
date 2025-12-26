import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/models/services_model.dart';
import 'package:esae_monie/presentation/screens/home/services/gift/type_of_gift.dart';
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
    final insurance1 = useState(
      ServicesModel(
        imagePath: 'assets/images/insurance1.png',
        title: 'Family Insurance',
        organizer: 'Family Plans Cover two or more members',
        targetAmount: 0,
        donatedAmount: 0,
      ),
    );

    final insurance2 = useState(
      ServicesModel(
        imagePath: 'assets/images/insurance2.png',
        title: 'House Insurance',
        organizer: 'Family Plans Cover two or more members',
        targetAmount: 0,
        donatedAmount: 0,
      ),
    );

    final insurance3 = useState(
      ServicesModel(
        imagePath: 'assets/images/insurance3.png',
        title: 'Health Insurance',
        organizer: 'Family Plans Cover two or more members',
        targetAmount: 0,
        donatedAmount: 0,
      ),
    );

    final familyOfferDeadline = DateTime.now().add(const Duration(days: 3));
    final houseOfferDeadline = DateTime.now().add(const Duration(days: 10));

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
