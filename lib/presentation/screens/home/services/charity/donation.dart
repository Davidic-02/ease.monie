import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/models/services_model.dart';
import 'package:esae_monie/presentation/screens/home/services/charity/charity_amount.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class Donation extends HookWidget {
  static const String routeName = 'Donation';
  const Donation({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final charity = ModalRoute.of(context)!.settings.arguments as ServicesModel;
    final donatedAmount = useState<double>(charity.donatedAmount);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomTopbar(
                title: 'Donation',
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
                    Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 180,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),

                              child: Image.asset(
                                charity.imagePath,
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            ),
                            AppSpacing.verticalSpaceMedium,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text(charity.title)],
                            ),
                            Text(
                              charity.organizer,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.6),
                                  ),
                            ),
                            AppSpacing.verticalSpaceHuge,
                          ],
                        ),
                      ),
                    ),

                    AppSpacing.verticalSpaceHuge,
                    Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),

                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/svgs/donation_checkbox.svg',
                                  ),
                                  AppSpacing.horizontalSpaceLarge,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Heads Foundation'),
                                          AppSpacing.horizontalSpaceSmall,
                                          SvgPicture.asset(
                                            'assets/svgs/heads_foundation_verify.svg',
                                          ),
                                        ],
                                      ),
                                      Text('Verified Foundation'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppSpacing.verticalSpaceMassive,
                    Text('Participant'),
                    AppSpacing.verticalSpaceMedium,
                    SizedBox(
                      height: 50,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: 0,
                            child: Image.asset('assets/images/donation2.png'),
                          ),
                          Positioned(
                            left: 20,
                            child: Image.asset('assets/images/donation2.png'),
                          ),
                          Positioned(
                            left: 40,
                            child: Image.asset('assets/images/donation3.png'),
                          ),
                          Positioned(
                            left: 60,
                            child: Image.asset('assets/images/9+.png'),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: GestureDetector(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.blueColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'View All',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    Donation.routeName,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.1),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 40,
                      ),
                      child: Button(
                        'Donate Now',
                        onPressed: () async {
                          final result = await Navigator.pushNamed(
                            context,
                            CharityAmount.routeName,
                            arguments: {
                              'charity': charity,
                              'accountName': charity.organizer,
                              'bankName': 'Charity Bank',
                              'accountNumber': '0000000000',
                            },
                          );

                          if (result != null && result is double) {
                            donatedAmount.value = donatedAmount.value + result;
                          }
                        },
                        color: AppColors.blueColor,
                      ),
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
