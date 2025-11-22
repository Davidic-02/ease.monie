//import 'package:esae_monie/presentation/screens/onboarding/forgot_password.dart';
import 'package:esae_monie/presentation/screens/onboarding/onboarding.dart';
import 'package:esae_monie/presentation/screens/auth/sign_in.dart';
import 'package:esae_monie/presentation/screens/onboarding/sign_up.dart';
import 'package:esae_monie/presentation/screens/onboarding/splash_screen.dart';
import 'package:esae_monie/presentation/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:esae_monie/presentation/screens/auth/forgot_password.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> get routes => {
    SplashScreen.routeName: (context) => const SplashScreen(),
    Onboarding.routeName: (context) => const Onboarding(),
    SignUpScreen.routeName: (context) => const SignUpScreen(),
    ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
    Login.routeName: (context) => const Login(),
    MainScreen.routeName: (_) => const MainScreen(),
  };
}
