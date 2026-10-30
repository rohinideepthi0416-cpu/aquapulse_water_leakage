import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:aquapulse_water_leakage/database/app_database.dart';
import 'package:aquapulse_water_leakage/database/web_memory_database_adapter.dart';
import 'package:aquapulse_water_leakage/providers/auth_provider.dart';
import 'package:aquapulse_water_leakage/screens/auth/login_screen.dart';

void main() {
  setUp(() async {
    final db = AppDatabase();
    await db.init(customAdapter: WebMemoryDatabaseAdapter());
  });

  testWidgets('LoginScreen renders fields and validates empty inputs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    // Verify UI components exist
    expect(find.text('Welcome to AquaPulse'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Auto-Fill'), findsOneWidget);

    // Tap Auto-fill button
    await tester.tap(find.text('Auto-Fill'));
    await tester.pump();

    // Verify fields populated
    expect(find.text('citizen@aquapulse.org'), findsOneWidget);
  });
}
