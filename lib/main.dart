import 'package:car_plaza/providers/auth_provider.dart';
import 'package:car_plaza/providers/chat_provider.dart';
import 'package:car_plaza/providers/saved_cars_provider.dart';
import 'package:car_plaza/utils/theme.dart';
import 'package:car_plaza/screens/auth/login_screen.dart';
import 'package:car_plaza/screens/onboarding/onboarding_screen.dart';
import 'package:car_plaza/utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool showOnboarding = true;

  @override
  void initState() {
    super.initState();
    checkFirstLaunch();
  }

  Future<void> checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('first_launch') ?? true;

    if (mounted) {
      setState(() {
        showOnboarding = isFirstLaunch;
      });
    }

    if (isFirstLaunch) {
      await prefs.setBool('first_launch', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Plaza',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: showOnboarding ? Routes.onboarding : Routes.login,
      onGenerateRoute: RouteGenerator.generateRoute,
      home: showOnboarding ? const OnboardingScreen() : const LoginScreen(),
    );
  }
}
