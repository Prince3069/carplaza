import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:car_plaza/screens/home_screen.dart';
import 'package:car_plaza/screens/car_detail_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/cars/:carId',
      builder: (context, state) => CarDetailScreen(
        carId: state.params['carId']!,
      ),
    ),
  ],
);

class WebRouter {
  static void goToCarDetail(BuildContext context, String carId) {
    if (kIsWeb) {
      context.go('/cars/$carId');
    } else {
      // Mobile navigation
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CarDetailScreen(carId: carId),
        ),
      );
    }
  }

  static void initRouteListener() {
    if (kIsWeb) {
      // Web-specific route listener initialization
    }
  }
}
