// import 'package:flutter/material.dart';
// import 'package:car_plaza/screens/home_screen.dart';
// import 'package:car_plaza/screens/search_screen.dart';
// import 'package:car_plaza/screens/sell_screen.dart';
// import 'package:car_plaza/screens/messages_screen.dart';
// import 'package:car_plaza/screens/profile_screen.dart';
// import 'package:car_plaza/screens/admin_panel.dart'; // Add this import

// class RouteManager {
//   static const String homePage = '/';
//   static const String searchPage = '/search';
//   static const String sellPage = '/sell';
//   static const String messagesPage = '/messages';
//   static const String profilePage = '/profile';
//   static const String adminPage = '/admin'; // Add this route

//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case homePage:
//         return MaterialPageRoute(builder: (_) => const HomeScreen());
//       case searchPage:
//         return MaterialPageRoute(builder: (_) => const SearchScreen());
//       case sellPage:
//         return MaterialPageRoute(builder: (_) => const SellScreen());
//       case messagesPage:
//         return MaterialPageRoute(builder: (_) => const MessagesScreen());
//       case profilePage:
//         return MaterialPageRoute(builder: (_) => const ProfileScreen());
//       case adminPage:
//         return MaterialPageRoute(
//             builder: (_) => const AdminPanel()); // Add this case
//       default:
//         throw const FormatException('Route not found! Check routes again!');
//     }
//   }
// }
// //

import 'package:car_plaza/test_upload_page.dart';
import 'package:flutter/material.dart';
import 'package:car_plaza/screens/home_screen.dart';
import 'package:car_plaza/screens/search_screen.dart';
import 'package:car_plaza/screens/sell_screen.dart';
import 'package:car_plaza/screens/messages_screen.dart';
import 'package:car_plaza/screens/profile_screen.dart';
import 'package:car_plaza/screens/admin_panel.dart';
// import 'package:car_plaza/screens/test_upload_page.dart';

class RouteManager {
  static const String homePage = '/';
  static const String searchPage = '/search';
  static const String sellPage = '/sell';
  static const String messagesPage = '/messages';
  static const String profilePage = '/profile';
  static const String adminPage = '/admin';
  static const String testUploadPage = '/test-upload';

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
      case adminPage:
        return MaterialPageRoute(builder: (_) => const AdminPanel());
      case testUploadPage:
        return MaterialPageRoute(builder: (_) => TestUploadPage());
      default:
        throw FormatException('Route not found! Check routes again!');
    }
  }
}
