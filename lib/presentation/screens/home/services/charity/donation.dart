import 'package:esae_monie/blocs/charity/charity_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/screens/home/services/charity/charity_amount.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Donation extends HookWidget {
  static const String routeName = 'Donation';
  const Donation({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<CharityBloc, CharityState>(
      builder: (context, state) {
        // 1️⃣ Get the currently selected charity from the bloc
        final currentCharity = state.charities[state.selectedCharityId];
        if (currentCharity == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: CustomTopbar(
                    title: 'Donation',
                    onTap: () => Navigator.pop(context),
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
                                    currentCharity.imagePath,
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                AppSpacing.verticalSpaceMedium,
                                Text(
                                  currentCharity.title,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                Text(
                                  currentCharity.organizer,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.6),
                                      ),
                                ),
                                AppSpacing.verticalSpaceHuge,
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
                                child: Image.asset(
                                  'assets/images/donation2.png',
                                ),
                              ),
                              Positioned(
                                left: 20,
                                child: Image.asset(
                                  'assets/images/donation2.png',
                                ),
                              ),
                              Positioned(
                                left: 40,
                                child: Image.asset(
                                  'assets/images/donation3.png',
                                ),
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
                            color: AppColors.blueColor,
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                CharityAmount.routeName,
                              );
                            },
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
      },
    );
  }
}
