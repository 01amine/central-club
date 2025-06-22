import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer_complex/features/auth/presentation/screens/login_screen.dart';
import 'package:soccer_complex/features/auth/presentation/screens/signup_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'di/injection_container.dart' as di;
import 'core/theme/theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/history/presentation/pages/details_screen.dart';
import 'features/home/presentation/cubit/bottom_navigation_cubit.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/reserve_field/domain/entities/field.dart';
import 'features/reserve_field/presentation/bloc/field_reservation_bloc.dart';
import 'features/reserve_field/presentation/screens/reserve_field_screen.dart';
import 'features/settings/presentation/pages/settings_screen.dart';
import 'features/splash/presentation/bloc/splash_bloc.dart';
import 'features/splash/presentation/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await di.init();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [SystemUiOverlay.top],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<SplashBloc>()..add(const InitializeApp()),
        ),
        BlocProvider(
          create: (_) => di.sl<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<OnboardingBloc>(),
        ),
        BlocProvider(
          create: (_) => BottomNavigationCubit(),
        ),
        BlocProvider(
          create: (_) => di.sl<FieldReservationBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Central Club',
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
        routes: {
          '/onboarding': (context) => BlocProvider(
                create: (_) => di.sl<OnboardingBloc>(),
                child: const OnboardingScreen(),
              ),
          '/home': (context) => BlocProvider(
              create: (_) => BottomNavigationCubit(), child: HomeLayout()),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/history_details': (context) => const HistoryDetailsScreen(),
          '/reserve_field': (context) {
            final args = ModalRoute.of(context)?.settings.arguments as Field?;

            return ReserveFieldScreen(fieldType: args!);
          },
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
