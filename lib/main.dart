// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

// import 'package:car_plaza/routes.dart';
// import 'package:car_plaza/utils/theme.dart';
// import 'package:car_plaza/screens/auth/login_screen.dart';
// import 'package:car_plaza/screens/home/home_screen.dart';
// import 'package:car_plaza/screens/onboarding/onboarding_screen.dart';

// import 'package:car_plaza/providers/auth_provider.dart' as local_auth;
// import 'package:car_plaza/providers/car_provider.dart';
// import 'package:car_plaza/providers/chat_provider.dart';
// import 'package:car_plaza/providers/theme_provider.dart';

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
//         ChangeNotifierProvider(create: (_) => local_auth.AuthProvider()),
//         ChangeNotifierProvider(create: (_) => ThemeProvider()),
//         ChangeNotifierProvider(create: (_) => CarProvider()),
//         ChangeNotifierProvider(create: (_) => ChatProvider()),
//       ],
//       child: Consumer<ThemeProvider>(
//         builder: (context, themeProvider, child) {
//           return MaterialApp(
//             title: 'Car Plaza',
//             debugShowCheckedModeBanner: false,
//             themeMode: themeProvider.themeMode,
//             theme: AppTheme.lightTheme,
//             darkTheme: AppTheme.darkTheme,
//             localizationsDelegates: const [
//               GlobalMaterialLocalizations.delegate,
//               GlobalWidgetsLocalizations.delegate,
//               GlobalCupertinoLocalizations.delegate,
//             ],
//             supportedLocales: const [Locale('en', '')],
//             onGenerateRoute: RouteGenerator.generateRoute,
//             home: const AuthWrapper(),
//           );
//         },
//       ),
//     );
//   }
// }

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<local_auth.AuthProvider>(context);

//     return StreamBuilder<User?>(
//       stream: authProvider.authStateChanges,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.active) {
//           final user = snapshot.data;

//           if (user == null) {
//             return const OnboardingScreen();
//           }

//           if (authProvider.userData == null) {
//             return const LoginScreen();
//           }

//           return const HomeScreen();
//         }

//         return const Scaffold(
//           backgroundColor: Colors.blue,
//           body: Center(
//             child: CircularProgressIndicator(
//               color: Colors.white,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:car_plaza/routes.dart';
import 'package:car_plaza/utils/theme.dart';
import 'package:car_plaza/screens/auth/login_screen.dart';
import 'package:car_plaza/screens/home/home_screen.dart';
import 'package:car_plaza/screens/onboarding/onboarding_screen.dart';

import 'package:car_plaza/providers/auth_provider.dart';
import 'package:car_plaza/providers/car_provider.dart';
import 'package:car_plaza/providers/chat_provider.dart';
import 'package:car_plaza/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize App Check (optional but recommended)
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

  // Initialize Crashlytics
  FlutterError.onError = (error) {
    FirebaseCrashlytics.instance.recordFlutterError(error);
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CarProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Car Plaza',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', '')],
            onGenerateRoute: RouteGenerator.generateRoute,
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return StreamBuilder<User?>(
      stream: authProvider.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;

          // Show loading if user data is still being fetched
          if (user != null && authProvider.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // No user logged in
          if (user == null) {
            return const OnboardingScreen();
          }

          // User logged in but no user data (shouldn't happen with new auth flow)
          if (authProvider.user == null) {
            return const Scaffold(
              body: Center(child: Text('Loading user data...')),
            );
          }

          // User fully authenticated with data
          return const HomeScreen();
        }

        // Initial loading
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
