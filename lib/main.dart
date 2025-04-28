// import 'package:car_plaza/screens/auth/login_screen.dart';
// import 'package:car_plaza/screens/home/home_screen.dart';
// import 'package:car_plaza/screens/profile/profile_screen.dart';
// import 'package:car_plaza/screens/sell/sell_screen.dart';
// import 'package:car_plaza/chat/chat_screen.dart';
// import 'package:car_plaza/splash/splash_screen.dart';
// import 'package:car_plaza/firebase_options.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
// import 'auth/auth_provider.dart'; // We will create this file too

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const CarPlazApp());
// }

// class CarPlazApp extends StatelessWidget {
//   const CarPlazApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'CarPlaz',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           fontFamily: 'Poppins',
//         ),
//         home: const SplashScreen(),
//       ),
//     );
//   }
// }

// class BottomNavScreen extends StatefulWidget {
//   const BottomNavScreen({super.key});

//   @override
//   State<BottomNavScreen> createState() => _BottomNavScreenState();
// }

// class _BottomNavScreenState extends State<BottomNavScreen> {
//   int _selectedIndex = 0;

//   static final List<Widget> _screens = [
//     HomeScreen(),
//     ChatScreen(),
//     SellCarScreen(),
//     ChatScreen(),
//     ProfileScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   final List<BottomNavigationBarItem> _bottomItems = const [
//     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//     BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
//     BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Sell'),
//     BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Message'),
//     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         items: _bottomItems,
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blueAccent,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//         type: BottomNavigationBarType.fixed,
//       ),
//     );
//   }
// }

// =================== lib/main.dart (updated for light/dark mode) ===================

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/sell/sell_screen.dart';
import 'screens/messages/messages_screen.dart';
import 'screens/profile/profile_screen.dart';
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
    return ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CarPlaz',
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.black,
        ),
        themeMode:
            ThemeMode.system, // This auto switches based on device setting
        initialRoute: '/',
        routes: appRoutes,
      ),
    );
  }
}

// =============================================================
