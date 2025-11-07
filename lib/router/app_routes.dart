import 'package:esae_monie/presentation/screens/onboarding/onboarding.dart';
import 'package:esae_monie/presentation/screens/onboarding/sign_up.dart';
import 'package:esae_monie/presentation/screens/onboarding/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> get routes => {
    SplashScreen.routeName: (context) => const SplashScreen(),
    Onboarding.routeName: (context) => const Onboarding(),
    SignUpScreen.routeName: (context) => const SignUpScreen(),
  };
}
