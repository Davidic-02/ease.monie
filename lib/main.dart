import 'package:esae_monie/blocs/onboarding/onboarding_bloc.dart';
import 'package:esae_monie/constants/theme_data.dart';
import 'package:esae_monie/presentation/screens/onboarding/splash_screen.dart';
import 'package:esae_monie/router/app_routes.dart';
import 'package:esae_monie/services/theme_services.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OnBoardingBloc>(create: (context) => OnBoardingBloc()),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: ThemeService.themeModeNotifier,
        builder: (_, ThemeMode currentMode, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: currentMode,

          title: 'Ease Monie',
          initialRoute: SplashScreen.routeName,
          routes: AppRoutes.routes,
        ),
      ),
    );
  }
}
