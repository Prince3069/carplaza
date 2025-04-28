import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/home/home_screen.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const CarPlazApp());
}

class CarPlazApp extends StatelessWidget {
  const CarPlazApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthService>(
      create: (_) => AuthService(),
      child: Consumer<AuthService>(
        builder: (context, authService, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'CarPlaz',
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            themeMode: ThemeMode.system, // Auto switch based on device setting

            // Use the authService to determine the initial route
            home: authService.currentUser != null
                ? const HomeScreen()
                : const OnboardingScreen(),

            routes: appRoutes, // Use the routes defined in routes.dart
          );
        },
      ),
    );
  }
}
