import 'package:car_plaza/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:car_plaza/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/services/auth_service.dart';

void main() {
  // Initialize Firebase before running tests
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets('App starts and shows home screen', (WidgetTester tester) async {
    // Build our app with mocked providers
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AuthService>(create: (_) => AuthService()),
          StreamProvider<User?>.value(
            value: Stream.value(null), // No user logged in initially
            initialData: null,
          ),
        ],
        child: const MaterialApp(
          home: MyApp(), // Explicit bool value
        ),
      ),
    );

    // Wait for animations/frame builds
    await tester.pumpAndSettle();

    // Verify that HomeScreen is visible (or your initial screen)
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
