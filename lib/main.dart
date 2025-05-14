import 'package:car_plaza/constants/app_colors.dart';
import 'package:car_plaza/services/device_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:car_plaza/providers/theme_provider.dart';
import 'package:car_plaza/providers/car_provider.dart';
import 'package:car_plaza/routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set preferred orientations for mobile
  await DeviceService.setPreferredOrientations();

  runApp(const CarPlazaApp());
}

class CarPlazaApp extends StatelessWidget {
  const CarPlazaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CarProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Car Plaza',
            theme: AppColors.lightTheme,
            darkTheme: AppColors.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: RouteManager.homePage,
            onGenerateRoute: RouteManager.generateRoute,
            builder: (context, child) {
              return ScrollConfiguration(
                behavior: AppScrollBehavior(),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}

// Custom scroll behavior for all platforms
class AppScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}
