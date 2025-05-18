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
import 'package:car_plaza/screens/admin_panel.dart'; // Add this import
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

  // Optional: Uncomment to setup first admin user (run once)
  // await setupFirstAdmin();

  runApp(const MyApp());
}

// Add this function (run this once to setup your first admin)
Future<void> setupFirstAdmin() async {
  try {
    // Replace with your admin email and password
    const adminEmail = 'admin@example.com';
    const adminPassword = 'securepassword123';

    // Create admin user in Firebase Auth
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: adminEmail,
      password: adminPassword,
    );

    // Set admin privileges in Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(credential.user!.uid)
        .set({
      'email': adminEmail,
      'isAdmin': true,
      'isVerifiedSeller': true,
      'createdAt': FieldValue.serverTimestamp(),
    });

    print('Admin user created successfully!');
  } catch (e) {
    print('Error creating admin user: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<DatabaseService>(create: (_) => DatabaseService()),
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().user,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Car Plaza',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AuthWrapper(),
        onGenerateRoute: RouteManager.generateRoute,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      // Return your login screen or onboarding
      return const HomeScreen(); // Or your auth screen
    }

    return const HomeScreen();
  }
}
