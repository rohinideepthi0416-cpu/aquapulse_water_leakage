import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aquapulse_water_leakage/widgets/status_badge.dart';
import 'package:aquapulse_water_leakage/widgets/severity_badge.dart';

void main() {
  group('Badges Widget Tests', () {
    testWidgets('StatusBadge displays correct text for all workflow states', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                StatusBadge(status: 'Pending'),
                StatusBadge(status: 'Reviewed'),
                StatusBadge(status: 'In Progress'),
                StatusBadge(status: 'Resolved'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Reviewed'), findsOneWidget);
      expect(find.text('In Progress'), findsOneWidget);
      expect(find.text('Resolved'), findsOneWidget);
    });

    testWidgets('SeverityBadge displays uppercase severity text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SeverityBadge(severity: 'Critical'),
                SeverityBadge(severity: 'High'),
                SeverityBadge(severity: 'Medium'),
                SeverityBadge(severity: 'Low'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('CRITICAL'), findsOneWidget);
      expect(find.text('HIGH'), findsOneWidget);
      expect(find.text('MEDIUM'), findsOneWidget);
      expect(find.text('LOW'), findsOneWidget);
    });
  });
}
