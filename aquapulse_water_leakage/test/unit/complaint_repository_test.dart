import 'package:flutter_test/flutter_test.dart';
import 'package:aquapulse_water_leakage/database/app_database.dart';
import 'package:aquapulse_water_leakage/database/web_memory_database_adapter.dart';
import 'package:aquapulse_water_leakage/repositories/complaint_repository.dart';
import 'package:aquapulse_water_leakage/repositories/notification_repository.dart';
import 'package:aquapulse_water_leakage/models/complaint_model.dart';

void main() {
  late AppDatabase db;
  late ComplaintRepository complaintRepo;
  late NotificationRepository notifRepo;

  setUp(() async {
    // Fresh in-memory database adapter for isolated testing
    db = AppDatabase();
    await db.init(customAdapter: WebMemoryDatabaseAdapter());
    complaintRepo = ComplaintRepository(dbInstance: db);
    notifRepo = NotificationRepository(dbInstance: db);
  });

  group('ComplaintRepository & Isolation Tests', () {
    test('User isolation: User only retrieves their own complaints', () async {
      // Create complaint for User 10
      final c1 = ComplaintModel(
        id: 'AP-TEST-0001',
        userId: 10,
        userName: 'User 10',
        title: 'Pipe Leak at User 10 House',
        description: 'Water leaking in driveway',
        leakageType: 'Pipeline Leak',
        location: '10 Maple Street',
        landmark: 'Near Lamp Post',
        severity: 'Medium',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
      await complaintRepo.createComplaint(c1);

      // Create complaint for User 20
      final c2 = ComplaintModel(
        id: 'AP-TEST-0002',
        userId: 20,
        userName: 'User 20',
        title: 'Tank Overflow at User 20 Block',
        description: 'Tank overflowing into street',
        leakageType: 'Overflowing Tank',
        location: '20 Oak Avenue',
        landmark: 'Opposite Park',
        severity: 'High',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
      await complaintRepo.createComplaint(c2);

      // User 10 must only retrieve c1
      final user10List = await complaintRepo.getUserComplaints(10);
      expect(user10List.any((c) => c.id == 'AP-TEST-0001'), isTrue);
      expect(user10List.any((c) => c.id == 'AP-TEST-0002'), isFalse);

      // User 20 must only retrieve c2
      final user20List = await complaintRepo.getUserComplaints(20);
      expect(user20List.any((c) => c.id == 'AP-TEST-0002'), isTrue);
      expect(user20List.any((c) => c.id == 'AP-TEST-0001'), isFalse);
    });

    test('Admin view retrieves all complaints across all citizens', () async {
      final adminComplaints = await complaintRepo.getAllComplaintsForAdmin();
      expect(adminComplaints, isNotEmpty);
      // Both seeded complaints should be visible
      expect(adminComplaints.any((c) => c.id == 'AP-2026-0001'), isTrue);
      expect(adminComplaints.any((c) => c.id == 'AP-2026-0002'), isTrue);
    });

    test(
      'Admin status update generates history record and in-app notification',
      () async {
        const complaintId = 'AP-2026-0001';

        // Admin updates status from In Progress to Resolved
        await complaintRepo.updateComplaintStatus(
          complaintId: complaintId,
          newStatus: 'Resolved',
          remarks: 'Replaced ruptured iron pipe section with modern HDPE.',
          adminName: 'Chief Water Engineer',
          resolutionDetails:
              'Permanent weld repair completed. Zero leakage observed.',
        );

        // 1. Verify complaint updated
        final updated = await complaintRepo.getComplaintById(complaintId);
        expect(updated?.status, 'Resolved');
        expect(updated?.resolutionDetails, contains('Permanent weld repair'));

        // 2. Verify status change history record
        final history = await complaintRepo.getComplaintHistory(complaintId);
        expect(history.any((h) => h.status == 'Resolved'), isTrue);
        expect(
          history.any((h) => h.updatedByName == 'Chief Water Engineer'),
          isTrue,
        );

        // 3. Verify in-app notification created for the citizen (userId = 1)
        final notifications = await notifRepo.getUserNotifications(1);
        final resolvedNotif = notifications.firstWhere(
          (n) => n.complaintId == complaintId,
        );
        expect(resolvedNotif.title, contains('Complaint Resolved'));
        expect(resolvedNotif.isRead, isFalse);
      },
    );

    test('Admin filters by severity and search query', () async {
      final criticalList = await complaintRepo.getAllComplaintsForAdmin(
        severityFilter: 'Critical',
      );
      for (final c in criticalList) {
        expect(c.severity, 'Critical');
      }

      final searchResults = await complaintRepo.getAllComplaintsForAdmin(
        searchQuery: 'Metro',
      );
      expect(searchResults, isNotEmpty);
      expect(
        searchResults.any((c) => c.landmark.contains('Metro Pillar')),
        isTrue,
      );
    });
  });
}
