import 'package:esae_monie/blocs/auth/auth_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/extensions/build_context.dart';
import 'package:esae_monie/presentation/widgets/card_actions.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';

class Cards extends HookWidget {
  static const String routeName = 'Cards';

  const Cards({super.key});
  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    final currentPage = useState(0);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTopbar(
                title: 'My Card',
                onTap: () => Navigator.pop(context),
              ),
              AppSpacing.verticalSpaceHuge,
              SizedBox(
                height: 220,
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (index) {
                    currentPage.value = index;
                  },
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: Stack(
                        children: [
                          Padding(
                            padding: index == 0
                                ? EdgeInsets.only(right: 10.0)
                                : EdgeInsets.only(left: 10.0),
                            child: SvgPicture.asset(
                              'assets/svgs/home_card.svg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          if (index == 0)
                            Positioned(
                              left: 16,
                              top: 16,
                              child: BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  if (state.loginStatus.isInProgress) {
                                    return const CircularProgressIndicator(
                                      color: Colors.white,
                                    );
                                  }

                                  if (state.user == null) {
                                    return const Text(
                                      "Loading user...",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }

                                  final user = state.user!;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Card Holder'),
                                      AppSpacing.verticalSpaceSmall,
                                      Text(
                                        user.displayName ?? 'User',
                                        style: context.textTheme.bodyLarge
                                            ?.copyWith(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            )
                          else
                            Positioned(
                              left: 16,
                              bottom: 16,
                              child: Text(
                                "Savings Account",
                                style: context.textTheme.bodyLarge?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              AppSpacing.verticalSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: currentPage.value == index ? 24 : 8,
                    height: 5,
                    decoration: BoxDecoration(
                      color: currentPage.value == index
                          ? Colors.blue
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              AppSpacing.verticalSpaceMassive,
              Row(
                children: [
                  Expanded(
                    child: ActionContainer(
                      label: 'Credit Limit',
                      label2: '271.00',
                      color: AppColors.greenColor,
                      onTap: () {},
                    ),
                  ),
                  AppSpacing.horizontalSpaceMedium,
                  Expanded(
                    child: ActionContainer(
                      label: 'Card Status',
                      label2: 'Active',
                      color: AppColors.redColor,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              AppSpacing.verticalSpaceHuge,
              Text(
                'Card Actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              AppSpacing.verticalSpaceMedium,
              BuildActionButton(
                image: 'assets/svgs/changePin.svg',
                label: 'Change Pin',
                color: AppColors.blueColor,
                onTap: () {},
                useToggle: false,
              ),
              AppSpacing.verticalSpaceMedium,
              BuildActionButton(
                image: 'assets/svgs/lockCard.svg',
                label: 'Lock Card',
                onTap: () {},
                useToggle: true,
              ),
              AppSpacing.verticalSpaceMedium,
              BuildActionButton(
                image: 'assets/svgs/deactivateCard.svg',
                label: 'Deactivate Card',
                useToggle: true,
              ),
              AppSpacing.verticalSpaceMassive,
              Button('Save', onPressed: () {}, color: Colors.blueAccent),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionContainer extends StatelessWidget {
  final String label;
  final String label2;
  final Color color;
  final VoidCallback onTap;
  const ActionContainer({
    super.key,
    required this.label,
    required this.label2,
    required this.color,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
            AppSpacing.verticalSpaceSmall,
            Row(
              children: [
                Text(
                  label2,
                  style: TextStyle(
                    fontSize: 18,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'USD',
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
