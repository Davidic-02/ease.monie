import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/extensions/build_context.dart';
import 'package:esae_monie/presentation/screens/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends HookWidget {
  const SplashScreen({super.key});

  static const String routeName = 'splash';

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          context.navigator.pushReplacementNamed(Onboarding.routeName);
        }
      });
      return null;
    }, []);
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Center(
          child: Lottie.asset(
            'assets/lottie/wave_animation.json',
            width: 200,
            height: 200,
            repeat: true,
            animate: true,
          ),
        ),
      ),
    );
  }
}
