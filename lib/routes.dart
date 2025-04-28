// =================== lib/routes.dart ===================

import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/sell/sell_screen.dart';
import 'screens/messages/messages_screen.dart';
import 'screens/profile/profile_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => HomeScreen(),
  '/login': (context) => LoginScreen(),
  '/sell': (context) => SellScreen(),
  '/messages': (context) => MessagesScreen(),
  '/profile': (context) => ProfileScreen(),
};

// ======================================================
