// // APP ROUTES CONFIGURATION
// import 'package:car_plaza/screens/auth/forgot_password_screen.dart';
// import 'package:car_plaza/screens/auth/login_screen.dart';
// import 'package:car_plaza/screens/auth/register_screen.dart';
// import 'package:car_plaza/screens/home/car_detail_screen.dart';
// import 'package:car_plaza/screens/home/category_screen.dart';
// import 'package:car_plaza/screens/home/home_screen.dart';
// import 'package:car_plaza/screens/messages/chat_screen.dart';
// import 'package:car_plaza/screens/messages/messages_screen.dart';
// import 'package:car_plaza/screens/onboarding/onboarding_screen.dart';
// import 'package:car_plaza/screens/profile/edit_profile_screen.dart';
// import 'package:car_plaza/screens/profile/payment_settings_screen.dart';
// import 'package:car_plaza/screens/profile/profile_screen.dart';
// import 'package:car_plaza/screens/profile/saved_cars_screen.dart';
// import 'package:car_plaza/screens/search/filter_screen.dart';
// import 'package:car_plaza/screens/search/search_screen.dart';
// import 'package:car_plaza/screens/sell/manage_listings_screen.dart';
// import 'package:car_plaza/screens/sell/sell_screen.dart';
// import 'package:car_plaza/screens/sell/upload_car_screen.dart';
// import 'package:flutter/material.dart';

// class RouteGenerator {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case '/':
//         return MaterialPageRoute(builder: (_) => const OnboardingScreen());
//       case '/login':
//         return MaterialPageRoute(builder: (_) => const LoginScreen());
//       case '/register':
//         return MaterialPageRoute(builder: (_) => const RegisterScreen());
//       case '/forgot-password':
//         return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
//       case '/home':
//         return MaterialPageRoute(builder: (_) => const HomeScreen());
//       case '/car-detail':
//         return MaterialPageRoute(builder: (_) => const CarDetailScreen());
//       case '/category':
//         return MaterialPageRoute(builder: (_) => const CategoryScreen());
//       case '/search':
//         return MaterialPageRoute(builder: (_) => const SearchScreen());
//       case '/filter':
//         return MaterialPageRoute(builder: (_) => const FilterScreen());
//       case '/sell':
//         return MaterialPageRoute(builder: (_) => const SellScreen());
//       case '/upload-car':
//         return MaterialPageRoute(builder: (_) => const UploadCarScreen());
//       case '/manage-listings':
//         return MaterialPageRoute(builder: (_) => const ManageListingsScreen());
//       case '/messages':
//         return MaterialPageRoute(builder: (_) => const MessagesScreen());
//       case '/chat':
//         return MaterialPageRoute(builder: (_) => const ChatScreen());
//       case '/profile':
//         return MaterialPageRoute(builder: (_) => const ProfileScreen());
//       case '/edit-profile':
//         return MaterialPageRoute(builder: (_) => const EditProfileScreen());
//       case '/saved-cars':
//         return MaterialPageRoute(builder: (_) => const SavedCarsScreen());
//       case '/payment-settings':
//         return MaterialPageRoute(builder: (_) => const PaymentSettingsScreen());
//       default:
//         return _errorRoute();
//     }
//   }

//   static Route<dynamic> _errorRoute() {
//     return MaterialPageRoute(
//       builder: (_) => Scaffold(
//         body: Center(
//           child: Text('Route not found'),
//         ),
//       ),
//     );
//   }
// }

// APP ROUTES CONFIGURATION
import 'package:car_plaza/screens/auth/forgot_password_screen.dart';
import 'package:car_plaza/screens/auth/login_screen.dart';
import 'package:car_plaza/screens/auth/register_screen.dart';
import 'package:car_plaza/screens/home/car_detail_screen.dart';
import 'package:car_plaza/screens/home/category_screen.dart';
import 'package:car_plaza/screens/home/home_screen.dart';
import 'package:car_plaza/screens/messages/chat_screen.dart';
import 'package:car_plaza/screens/messages/messages_screen.dart';
import 'package:car_plaza/screens/onboarding/onboarding_screen.dart';
import 'package:car_plaza/screens/profile/edit_profile_screen.dart';
import 'package:car_plaza/screens/profile/payment_settings_screen.dart';
import 'package:car_plaza/screens/profile/profile_screen.dart';
import 'package:car_plaza/screens/profile/saved_cars_screen.dart';
import 'package:car_plaza/screens/search/filter_screen.dart';
import 'package:car_plaza/screens/search/search_screen.dart';
import 'package:car_plaza/screens/sell/manage_listings_screen.dart';
import 'package:car_plaza/screens/sell/sell_screen.dart';
import 'package:car_plaza/screens/sell/upload_car_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/forgot-password':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/car-detail':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => CarDetailScreen(
              car: args['car'],
              category: args['category'],
            ),
          );
        }
        return _errorRoute();
      case '/category':
        return MaterialPageRoute(builder: (_) => const CategoryScreen());
      case '/search':
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case '/filter':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => FilterScreen(
              filters: args['filters'],
            ),
          );
        }
        return MaterialPageRoute(builder: (_) => const FilterScreen());
      case '/sell':
        return MaterialPageRoute(builder: (_) => const SellScreen());
      case '/upload-car':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => UploadCarScreen(
              car: args['car'],
              user: args['user'],
            ),
          );
        }
        return MaterialPageRoute(builder: (_) => const UploadCarScreen());
      case '/manage-listings':
        return MaterialPageRoute(builder: (_) => const ManageListingsScreen());
      case '/messages':
        return MaterialPageRoute(builder: (_) => const MessagesScreen());
      case '/chat':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => ChatScreen(
              user: args['user'],
              savedCars: args['savedCars'],
            ),
          );
        }
        return _errorRoute();
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/edit-profile':
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case '/saved-cars':
        return MaterialPageRoute(builder: (_) => const SavedCarsScreen());
      case '/payment-settings':
        return MaterialPageRoute(builder: (_) => const PaymentSettingsScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Route not found'),
        ),
      ),
    );
  }
}
