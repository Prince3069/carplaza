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
import 'package:car_plaza/screens/admin_panel.dart';
import 'package:car_plaza/screens/admin_setup_screen.dart';
import 'package:car_plaza/screens/home_screen.dart';
import 'package:car_plaza/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final adminExists = await _checkAdminExists();
  runApp(MyApp(needsAdminSetup: !adminExists));
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
    debugPrint('Error checking admin: $e');
    return true; // Fallback to prevent setup loop
  }
}

class MyApp extends StatelessWidget {
  final bool needsAdminSetup;
  const MyApp({super.key, required this.needsAdminSetup});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        StreamProvider<User?>.value(
          value: FirebaseAuth.instance.authStateChanges(),
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
        home: needsAdminSetup ? const AdminSetupScreen() : const AuthWrapper(),
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
      return const HomeScreen();
    }

    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const HomeScreen();
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        return userData['isAdmin'] == true
            ? const AdminPanel()
            : const HomeScreen();
      },
    );
  }
}
