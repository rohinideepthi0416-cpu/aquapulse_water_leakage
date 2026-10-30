import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aquapulse_water_leakage/widgets/stat_card.dart';

void main() {
  testWidgets('StatCard displays title, count, and triggers onTap callback', (
    WidgetTester tester,
  ) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatCard(
            title: 'Critical Leaks',
            count: 7,
            icon: Icons.warning_rounded,
            accentColor: Colors.red,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Critical Leaks'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    expect(find.byIcon(Icons.warning_rounded), findsOneWidget);

    await tester.tap(find.byType(StatCard));
    expect(tapped, isTrue);
  });
}
