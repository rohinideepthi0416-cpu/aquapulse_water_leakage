import 'package:flutter_test/flutter_test.dart';
import 'package:aquapulse_water_leakage/app.dart';
import 'package:aquapulse_water_leakage/database/app_database.dart';
import 'package:aquapulse_water_leakage/database/web_memory_database_adapter.dart';

void main() {
  setUp(() async {
    final db = AppDatabase();
    await db.init(customAdapter: WebMemoryDatabaseAdapter());
  });

  testWidgets('AquaPulseApp loads and renders splash screen smoke test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AquaPulseApp());

    // Expect splash screen branding to be present
    expect(find.text('AquaPulse'), findsOneWidget);
    expect(find.text('Every Drop Counts.'), findsOneWidget);

    // Advance past splash navigation timer so screen transitions and timers settle
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pump();
  });
}
