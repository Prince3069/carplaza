import 'package:flutter/material.dart';
import 'package:car_plaza/screens/home_screen.dart';
import 'package:car_plaza/screens/search_screen.dart';
import 'package:car_plaza/screens/sell_screen.dart';
import 'package:car_plaza/screens/messages_screen.dart';
import 'package:car_plaza/screens/profile_screen.dart';

class RouteManager {
  static const String homePage = '/';
  static const String searchPage = '/search';
  static const String sellPage = '/sell';
  static const String messagesPage = '/messages';
  static const String profilePage = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case searchPage:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case sellPage:
        return MaterialPageRoute(builder: (_) => const SellScreen());
      case messagesPage:
        return MaterialPageRoute(builder: (_) => const MessagesScreen());
      case profilePage:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        throw FormatException('Route not found! Check routes again!');
    }
  }
}
