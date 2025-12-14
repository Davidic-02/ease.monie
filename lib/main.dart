import 'package:esae_monie/blocs/auth/auth_bloc.dart';
import 'package:esae_monie/blocs/bank_verification/bank_verification_bloc.dart';
import 'package:esae_monie/blocs/onboarding/onboarding_bloc.dart';
import 'package:esae_monie/constants/theme_data.dart';
import 'package:esae_monie/presentation/screens/auth/sign_in.dart';
import 'package:esae_monie/presentation/screens/onboarding/onboarding.dart';
import 'package:esae_monie/router/app_routes.dart';
import 'package:esae_monie/services/service_locator.dart';
import 'package:esae_monie/services/theme_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await setupServiceLocator();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OnBoardingBloc>(
          create: (context) => OnBoardingBloc(FirebaseAuth.instance),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuth.instance),
        ),
        BlocProvider<VerificationBloc>(create: (context) => VerificationBloc()),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: ThemeService.themeModeNotifier,
        builder: (_, ThemeMode currentMode, __) => ToastificationWrapper(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: currentMode,
            initialRoute: Login.routeName,
            routes: AppRoutes.routes,
          ),
        ),
      ),
    );
  }
}
