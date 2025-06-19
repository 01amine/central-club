// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    if (routeSettings.arguments != null) {
      final Map<String, dynamic> args =
          routeSettings.arguments as Map<String, dynamic>;
    }
    switch (routeSettings.name) {
      // case Routes.home:
      //   return buildScreen(
      //     screen: BlocProvider(
      //         create: (_) => BottomNavigationCubit(), child: HomeScreen()),
      //   );

      // case Routes.login:
      //   return buildScreen(screen: const Login());

      // case Routes.successful:
      //   return buildScreen(screen: const SuccessRecord());

      // case Routes.qr_scanner:
      //   return buildScreen(screen:  QrCodeScanner());

      default:
        return buildScreen(
          screen: const DefaultScreen(),
        );
    }
  }

  Route onUnknownRoute(RouteSettings routeSettings) {
    return buildScreen(
      screen: const DefaultScreen(),
    );
  }
}

class DefaultScreen extends StatelessWidget {
  const DefaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "404",
        ),
      ),
    );
  }
}

PageRouteBuilder<dynamic> buildScreen({
  required Widget screen,
  Duration? duration,
}) {
  return PageRouteBuilder(
    transitionDuration: duration ?? const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return screen;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: animation.drive(
          Tween(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).chain(
            CurveTween(curve: Curves.ease),
          ),
        ),
        child: child,
      );
    },
  );
}
