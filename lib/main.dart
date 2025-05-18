// import 'package:car_plaza/screens/home_screen.dart';
// import 'package:car_plaza/services/auth_service.dart';
// import 'package:car_plaza/services/database_service.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         Provider<AuthService>(create: (_) => AuthService()),
//         Provider<DatabaseService>(create: (_) => DatabaseService()),
//       ],
//       child: MaterialApp(
//         title: 'Car Plaza',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//         ),
//         home: const HomeScreen(),
//       ),
//     );
//   }
// }

import 'package:car_plaza/routes.dart';
import 'package:car_plaza/screens/home_screen.dart';
import 'package:car_plaza/screens/admin_panel.dart';
import 'package:car_plaza/screens/admin_setup_screen.dart';
import 'package:car_plaza/services/auth_service.dart';
import 'package:car_plaza/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
      home: const AuthCheckScreen(),
      onGenerateRoute: RouteManager.generateRoute,
    );
  }
}

class AuthCheckScreen extends StatelessWidget {
  const AuthCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = Provider.of<User?>(context);

    if (user == null) {
      // User is not logged in, show home screen or login screen
      return const HomeScreen();
    }

    // User is logged in, check if admin setup is needed
    return FutureBuilder<bool>(
      future: _checkAdminExists(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          // If we can't check admin status, proceed to home screen
          return const HomeScreen();
        }

        final adminExists = snapshot.data!;
        if (!adminExists) {
          return const AdminSetupScreen();
        }

        // Check if current user is admin
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (userSnapshot.hasError || !userSnapshot.hasData) {
              return const HomeScreen();
            }

            final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
            final isAdmin = userData?['isAdmin'] == true;

            return isAdmin ? const AdminPanel() : const HomeScreen();
          },
        );
      },
    );
  }
}

Future<bool> _checkAdminExists() async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('isAdmin', isEqualTo: true)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  } catch (e) {
    print('Error checking admin existence: $e');
    // If we can't check, assume admin exists to prevent setup loop
    return true;
  }
}
