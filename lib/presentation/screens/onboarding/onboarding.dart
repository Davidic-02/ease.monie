import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/extensions/build_context.dart';
import 'package:esae_monie/presentation/screens/onboarding/sign_up.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends HookWidget {
  const Onboarding({super.key});

  static const String routeName = 'onboarding';

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    final pageController = usePageController();

    final img1Offset =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0.08, 0.04),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
          ),
        );

    final img2Offset =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0.12, -0.06),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
          ),
        );

    final img3Offset =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.08, 0.10),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
          ),
        );

    return Scaffold(
      backgroundColor: Color(0xFF23303B),

      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 460,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: -250,
                    child: SlideTransition(
                      position: img1Offset,
                      child: Image.asset(
                        'assets/images/first.png',
                        width: 600,
                        height: 300,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 160,
                    left: -150,
                    child: SlideTransition(
                      position: img2Offset,
                      child: Image.asset(
                        'assets/images/second.png',
                        width: 600,
                        height: 300,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 200,
                    left: 80,
                    child: SlideTransition(
                      position: img3Offset,
                      child: Image.asset(
                        'assets/images/third.png',
                        width: 600,
                        height: 300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: PageView(
                  controller: pageController,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        Text(
                          "Manage your\nPayment with",
                          style: context.textTheme.displayMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 35,
                          ),
                        ),
                        Text(
                          "mobile banking ",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 35,
                          ),
                        ),
                        AppSpacing.verticalSpaceMedium,
                        Text(
                          "A convenient way to manage your money\nsecurely from mobile devices.",
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        Text(
                          "A loan for every\ndream with",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "mobile banking",
                          style: context.textTheme.displayMedium?.copyWith(
                            color: AppColors.primaryColor,
                            fontSize: 35,
                          ),
                        ),
                        AppSpacing.verticalSpaceMedium,
                        Text(
                          "A loan facility that provides you financial\nassistance whenever you need",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: pageController,
                    count: 2,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Colors.white,
                      dotHeight: 8,
                      dotWidth: 16,
                      spacing: 8,
                      expansionFactor: 3,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: const Color(0xFF4F5962),
                    ),
                    onPressed: () {
                      context.navigator.pushNamedAndRemoveUntil(
                        SignUpScreen.routeName,
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "Skip",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
