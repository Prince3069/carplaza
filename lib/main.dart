// import 'package:car_plaza/screens/admin_panel.dart';
// import 'package:car_plaza/screens/admin_setup_screen.dart';
// import 'package:car_plaza/screens/home_screen.dart';
// import 'package:car_plaza/screens/profile_screen.dart';
// import 'package:car_plaza/screens/sell_screen.dart';
// import 'package:car_plaza/services/auth_service.dart';
// import 'package:car_plaza/services/database_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'firebase_options.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   runApp(
//     MultiProvider(
//       providers: [
//         Provider<AuthService>(create: (_) => AuthService()),
//         Provider<DatabaseService>(create: (_) => DatabaseService()),
//         StreamProvider<User?>.value(
//           value: FirebaseAuth.instance.authStateChanges(),
//           initialData: null,
//         ),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Car Plaza',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const AuthWrapper(),
//       routes: {
//         '/home': (context) => const HomeScreen(),
//         '/profile': (context) => const ProfileScreen(),
//         '/sell': (context) => const SellScreen(),
//       },
//     );
//   }
// }

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthService>(context);
//     final user = auth.currentUser;

//     if (user == null) {
//       return const ProfileScreen(); // Force profile completion
//     }

//     return FutureBuilder<bool>(
//       future: auth.isAdmin(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Scaffold(
//               body: Center(child: CircularProgressIndicator()));
//         }

//         final isAdmin = snapshot.data!;
//         return isAdmin ? const AdminPanel() : const HomeScreen();
//       },
//     );
//   }
// }

// import 'package:car_plaza/route_manager.dart';
import 'package:car_plaza/routes.dart';
import 'package:car_plaza/screens/admin_panel.dart';
import 'package:car_plaza/screens/home_screen.dart';
import 'package:car_plaza/screens/profile_screen.dart';
// import 'package:car_plaza/screens/test_upload_page.dart';
import 'package:car_plaza/services/auth_service.dart';
import 'package:car_plaza/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<DatabaseService>(create: (_) => DatabaseService()),
        StreamProvider<User?>.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Plaza',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      onGenerateRoute: RouteManager.generateRoute,
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final user = auth.currentUser;

    if (user == null) {
      return const ProfileScreen();
    }

    return FutureBuilder<bool>(
      future: auth.isAdmin(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data! ? const AdminPanel() : const HomeScreen();
      },
    );
  }
}
