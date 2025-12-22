import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/models/services_model.dart';
import 'package:esae_monie/presentation/screens/home/services/gift/type_of_gift.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:esae_monie/presentation/widgets/services_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Gift extends HookWidget {
  static const String routeName = 'Gift';
  const Gift({super.key});

  @override
  Widget build(BuildContext context) {
    final gift1 = useState(
      ServicesModel(
        imagePath: 'assets/images/gift1.png',
        title: 'Eid Gift',
        organizer: 'Send Eid Gift to your loved ones',
        targetAmount: 0,
        donatedAmount: 0,
      ),
    );

    final gift2 = useState(
      ServicesModel(
        imagePath: 'assets/images/gift2.png',
        title: 'Birthday Gift',
        organizer: 'Send Birthday Gift to your loved ones',
        targetAmount: 0,
        donatedAmount: 0,
      ),
    );

    final gift3 = useState(
      ServicesModel(
        imagePath: 'assets/images/gift3.png',
        title: 'Marriage Gift',
        organizer: 'Send Marriage Gift to your loved ones',
        targetAmount: 0,
        donatedAmount: 0,
      ),
    );

    final eidOfferDeadline = DateTime.now().add(const Duration(days: 3));
    final birthdayOfferDeadline = DateTime.now().add(const Duration(days: 10));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomTopbar(
                title: 'Gift',
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
                      service: gift1.value,
                      deadlineDate: eidOfferDeadline,
                      showProgressBar: false,
                      showPercentageBadge: false,
                      buttonText: 'Send',
                      bottomLeftText: '🎁 Get 10% Cashback',
                      onButtonPressed: () {
                        Navigator.pushNamed(
                          context,
                          TypeOfGift.routeName,
                          arguments: gift1.value,
                        );
                      },
                    ),

                    AppSpacing.verticalSpaceHuge,

                    ServiceCard(
                      service: gift2.value,
                      deadlineDate: birthdayOfferDeadline,
                      showProgressBar: false,
                      showPercentageBadge: false,
                      buttonText: 'Send',
                      bottomLeftText: '🎁 Get 30% Cashback',
                      onButtonPressed: () {
                        Navigator.pushNamed(
                          context,
                          TypeOfGift.routeName,
                          arguments: gift2.value,
                        );
                      },
                    ),

                    AppSpacing.verticalSpaceHuge,

                    ServiceCard(
                      service: gift3.value,
                      showProgressBar: false,
                      showPercentageBadge: false,
                      showDaysLeftBadge: false,
                      buttonText: 'Send',
                      bottomLeftText: '🎁 Get 20% Cashback',
                      onButtonPressed: () {
                        Navigator.pushNamed(
                          context,
                          TypeOfGift.routeName,
                          arguments: gift3.value,
                        );
                      },
                    ),

                    AppSpacing.verticalSpaceMedium,

                    ServiceCard(
                      service: gift1.value,
                      deadlineDate: eidOfferDeadline,
                      showProgressBar: false,
                      showPercentageBadge: false,
                      buttonText: 'Send',
                      bottomLeftText: '🎁 Get 10% Cashback',
                      onButtonPressed: () {
                        Navigator.pushNamed(
                          context,
                          TypeOfGift.routeName,
                          arguments: gift1.value,
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
