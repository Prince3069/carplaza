import 'package:car_plaza/screens/auth/login_screen.dart';
import 'package:car_plaza/screens/auth/register_screen.dart';
import 'package:car_plaza/screens/messages/messages_screen.dart';
import 'package:car_plaza/screens/profile/profile_screen.dart';
import 'package:car_plaza/screens/sell/sell_screen.dart';
import 'package:flutter/material.dart';

import 'screens/onboarding/onboarding_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const OnboardingScreen(), // Default first screen now
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/sell': (context) => const SellScreen(),
  '/messages': (context) => const MessagesScreen(),
  '/profile': (context) => const ProfileScreen(),
};
