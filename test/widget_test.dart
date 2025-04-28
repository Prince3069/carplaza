import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:car_plaza/main.dart';

void main() {
  testWidgets('App starts and shows onboarding screen',
      (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const CarPlazApp());

    // Wait for animations/frame builds
    await tester.pumpAndSettle();

    // Verify that OnboardingScreen is visible
    expect(find.text('Get Started'),
        findsOneWidget); // <- Change this based on a real text in your OnboardingScreen
  });
}
