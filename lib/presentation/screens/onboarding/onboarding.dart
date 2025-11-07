//import 'package:flutter/src/widgets/framework.dart';
import 'package:esae_monie/constants/color.dart';
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

    // Page controller for PageView
    final pageController = usePageController();

    // animations
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
            // top animated stack (cartoons)
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
                        'assets/first.png',
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
                        'assets/second.png',
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
                        'assets/third.png',
                        width: 600,
                        height: 300,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 👇 PageView with 2 pages of text
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
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "mobile banking ",
                          style: TextStyle(color: myColor, fontSize: 35),
                        ),
                        SizedBox(height: 10),
                        Text(
                          style: TextStyle(color: Colors.white54),
                          "A convenient way to manage your money\nsecurely from mobile devices.",
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(height: 30),
                        Text(
                          "A loan for every\ndream with",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          style: TextStyle(
                            color: myColor,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                          "mobile banking",
                        ),
                        SizedBox(height: 5),
                        Text(
                          "A loan facility that provides you financial\nassistance whenever you need",
                          style: TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 👇 SmoothPageIndicator + Button row
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
                      dotWidth: 16, // makes them rectangular
                      spacing: 8,
                      expansionFactor: 3,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // 👈 rounded corners
                      ),
                      backgroundColor: const Color(0xFF4F5962),
                    ),
                    onPressed: () {},
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
