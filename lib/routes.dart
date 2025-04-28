import 'package:flutter/material.dart';
import 'package:car_plaza/screens/auth/login_screen.dart';
import 'package:car_plaza/screens/auth/register_screen.dart';
import 'package:car_plaza/screens/auth/forgot_password_screen.dart';
import 'package:car_plaza/screens/home/home_screen.dart';
import 'package:car_plaza/screens/messages/messages_screen.dart';
import 'package:car_plaza/screens/profile/profile_screen.dart';
import 'package:car_plaza/screens/sell/sell_screen.dart';
import 'package:car_plaza/screens/onboarding/onboarding_screen.dart';
import 'package:car_plaza/screens/search_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const OnboardingScreen(), // Default first screen
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/forgot_password': (context) => const ForgotPasswordScreen(),
  '/home': (context) => const HomeScreen(), // Add home route
  '/search': (context) => const SearchScreen(),
  '/sell': (context) => const SellScreen(),
  '/messages': (context) => const MessagesScreen(),
  '/profile': (context) => const ProfileScreen(),
};
