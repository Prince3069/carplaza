import 'package:car_plaza/screens/auth/forgot_password_screen.dart';
import 'package:car_plaza/screens/auth/login_screen.dart';
import 'package:car_plaza/screens/auth/register_screen.dart';
import 'package:car_plaza/screens/car_details/car_details_screen.dart';
import 'package:car_plaza/screens/home/home_screen.dart';
import 'package:car_plaza/screens/messages/chat_screen.dart';
import 'package:car_plaza/screens/onboarding/onboarding_screen.dart';
import 'package:car_plaza/screens/profile/edit_profile.dart';
import 'package:car_plaza/screens/profile/profile_screen.dart';
import 'package:car_plaza/screens/profile/saved_cars.dart';
import 'package:car_plaza/screens/search/search_screen.dart';
import 'package:car_plaza/screens/sell/manage_listings.dart';
import 'package:car_plaza/screens/sell/sell_screen.dart';
import 'package:car_plaza/screens/sell/upload_car.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String search = '/search';
  static const String sell = '/sell';
  static const String uploadCar = '/upload-car';
  static const String manageListings = '/manage-listings';
  static const String messages = '/messages';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String savedCars = '/saved-cars';
  static const String carDetails = '/car-details';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case Routes.sell:
        return MaterialPageRoute(builder: (_) => const SellScreen());
      case Routes.uploadCar:
        return MaterialPageRoute(builder: (_) => const UploadCarScreen());
      case Routes.manageListings:
        return MaterialPageRoute(builder: (_) => const ManageListingsScreen());
      case Routes.messages:
        // Placeholder - replace with actual MessagesScreen
        return MaterialPageRoute(builder: (_) => const Scaffold());
      case Routes.chat:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ChatScreen(
            receiverId: args['receiverId'],
            receiverName: args['receiverName'],
          ),
        );
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case Routes.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case Routes.savedCars:
        return MaterialPageRoute(builder: (_) => const SavedCarsScreen());
      case Routes.carDetails:
        final carId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => CarDetailsScreen(carId: carId),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
