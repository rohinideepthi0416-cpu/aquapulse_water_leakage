import 'package:aquapulse_water_leakage/database/app_database.dart';
import 'package:aquapulse_water_leakage/database/web_memory_database_adapter.dart';
import 'package:aquapulse_water_leakage/models/complaint_model.dart';
import 'package:aquapulse_water_leakage/providers/auth_provider.dart';
import 'package:aquapulse_water_leakage/providers/complaint_provider.dart';
import 'package:aquapulse_water_leakage/screens/admin/admin_dashboard_screen.dart';
import 'package:aquapulse_water_leakage/screens/admin/admin_complaint_details_screen.dart';
import 'package:aquapulse_water_leakage/screens/auth/login_screen.dart';
import 'package:aquapulse_water_leakage/screens/auth/register_screen.dart';
import 'package:aquapulse_water_leakage/screens/complaints/complaint_details_screen.dart';
import 'package:aquapulse_water_leakage/screens/complaints/complaint_success_screen.dart';
import 'package:aquapulse_water_leakage/screens/complaints/report_complaint_screen.dart';
import 'package:aquapulse_water_leakage/screens/onboarding/onboarding_screen.dart';
import 'package:aquapulse_water_leakage/widgets/complaint_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

const _phoneWidths = [320.0, 360.0, 390.0, 430.0];

final _complaint = ComplaintModel(
  id: 'AP-2026-00012345',
  userId: 1,
  userName: 'AquaPulse Citizen with a long name',
  userPhone: '+91 98765 43210',
  title: 'Water leaking from a damaged underground pipeline',
  description:
      'Water is flowing continuously from a damaged pipeline near the street.',
  leakageType: 'Drainage / Sewage Leak',
  location: 'A very long street and neighborhood location description',
  landmark: 'Near the community park entrance',
  severity: 'Critical',
  status: 'In Progress',
  createdAt: '2026-10-16T10:00:00.000',
  updatedAt: '2026-10-16T11:00:00.000',
);

void main() {
  setUp(() async {
    await AppDatabase().init(customAdapter: WebMemoryDatabaseAdapter());
  });

  testWidgets('login and registration fit narrow screens with the keyboard', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 280);

    for (final width in _phoneWidths) {
      tester.view.physicalSize = Size(width, 568);
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
          child: const MaterialApp(home: LoginScreen()),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull, reason: 'Login at $width px');

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
          child: const MaterialApp(home: RegisterScreen()),
        ),
      );
      await tester.pump();
      final registrationError = tester.takeException();
      expect(registrationError, isNull, reason: 'Registration at $width px');
    }

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    tester.view.resetViewInsets();
  });

  testWidgets('complaint cards and detail screens fit phone widths', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;

    for (final width in _phoneWidths) {
      tester.view.physicalSize = Size(width, 568);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ComplaintCard(
                complaint: _complaint,
                showUserInfo: true,
                onTap: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      final cardError = tester.takeException();
      expect(cardError, isNull, reason: 'Complaint card at $width px');

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ComplaintProvider(),
          child: MaterialApp(
            home: ComplaintDetailsScreen(complaint: _complaint),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(
        tester.takeException(),
        isNull,
        reason: 'Complaint details at $width px',
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => ComplaintProvider()),
          ],
          child: MaterialApp(
            home: AdminComplaintDetailsScreen(complaint: _complaint),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(
        tester.takeException(),
        isNull,
        reason: 'Admin complaint details at $width px',
      );

      await tester.pumpWidget(
        MaterialApp(home: ComplaintSuccessScreen(complaint: _complaint)),
      );
      await tester.pump();
      expect(
        tester.takeException(),
        isNull,
        reason: 'Complaint success at $width px',
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => ComplaintProvider()),
          ],
          child: const MaterialApp(home: ReportComplaintScreen()),
        ),
      );
      await tester.pump();
      final reportError = tester.takeException();
      expect(reportError, isNull, reason: 'Complaint form at $width px');

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => ComplaintProvider()),
          ],
          child: const MaterialApp(home: AdminDashboardScreen()),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(
        tester.takeException(),
        isNull,
        reason: 'Admin dashboard at $width px',
      );
    }

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('onboarding remains scrollable on compact phone screens', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;

    for (final width in _phoneWidths) {
      tester.view.physicalSize = Size(width, 568);
      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));
      await tester.pump();
      expect(tester.takeException(), isNull, reason: 'Onboarding at $width px');
    }

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
