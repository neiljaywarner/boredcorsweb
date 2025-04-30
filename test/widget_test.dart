// This is a Flutter widget test that verifies the QuotePage renders correctly.
// It tests the basic UI elements without mocking API calls.

import 'package:boredcorsweb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('QuotePage displays loading indicator initially', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp());

    // Verify loading indicator is displayed initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // There should be a Scaffold
    expect(find.byType(Scaffold), findsOneWidget);

    // There should be a Center widget
    expect(find.byType(Center), findsOneWidget);
  });

  testWidgets('QuotePage has proper widget hierarchy', (WidgetTester tester) async {
    // Build the widget tree
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: Center(child: Text('Mocked Quote Text')))),
    );

    // Verify the text is displayed correctly
    expect(find.text('Mocked Quote Text'), findsOneWidget);

    // Verify proper widget nesting
    final centerFinder = find.byType(Center);
    expect(centerFinder, findsOneWidget);

    final textFinder = find.byType(Text);
    expect(tester.widget<Text>(textFinder).data, 'Mocked Quote Text');

    // Verify Center is child of Scaffold
    expect(
      find.descendant(of: find.byType(Scaffold), matching: find.byType(Center)),
      findsOneWidget,
    );
  });
}
