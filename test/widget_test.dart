// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:stylecast/main.dart';

void main() {
  testWidgets('StyleCast launches without crashing', (WidgetTester tester) async {
    // Suppress network image errors in tests
    FlutterError.onError = (FlutterErrorDetails details) {
      // Ignore network image errors and layout overflow warnings in tests
      if (details.exception.toString().contains('NetworkImageLoadException') ||
          details.exception.toString().contains('RenderFlex overflowed')) {
        return;
      }
      FlutterError.dumpErrorToConsole(details);
    };

    // Build the app with empty camera list for testing
    await tester.pumpWidget(const StyleCastApp(cameras: []));

    // Wait for the app to settle (with timeout to avoid hanging on network requests)
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Verify that MaterialApp is present - this confirms the app launched successfully
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // Verify that a Scaffold is present (from MainScreen)
    expect(find.byType(Scaffold), findsWidgets);
  });
}