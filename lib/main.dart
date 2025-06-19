import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer_complex/features/auth/presentation/screens/login_screen.dart';
import 'package:soccer_complex/features/auth/presentation/screens/signup_screen.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'di/injection_container.dart' as di;
import 'core/theme/theme.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/splash/presentation/bloc/splash_bloc.dart';
import 'features/splash/presentation/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await dotenv.load(fileName: ".env");
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Central Club',
      theme: AppTheme.darkTheme,
      home: BlocProvider(
        create: (_) => di.sl<SplashBloc>(),
        child: const SplashScreen(),
      ),
      routes: {
        '/onboarding': (context) => BlocProvider(
              create: (_) => di.sl<OnboardingBloc>(),
              child: const OnboardingScreen(),
            ),
        '/home': (context) => HomeLayout(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
      },
    );
  }
}
