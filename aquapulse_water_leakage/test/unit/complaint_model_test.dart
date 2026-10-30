import 'package:flutter_test/flutter_test.dart';
import 'package:aquapulse_water_leakage/models/complaint_model.dart';

void main() {
  group('ComplaintModel Unit Tests', () {
    final complaint = ComplaintModel(
      id: 'AP-2026-0009',
      userId: 101,
      userName: 'Test Citizen',
      userPhone: '9876543210',
      title: 'Major pipeline rupture near market',
      description: 'Continuous drinking water wastage across the main road.',
      leakageType: 'Pipeline Leak',
      location: 'Central Market Square',
      landmark: 'Near Clock Tower',
      severity: 'Critical',
      status: 'Pending',
      createdAt: '2026-10-16T10:00:00.000',
      updatedAt: '2026-10-16T10:00:00.000',
    );

    test('Serializes to map correctly', () {
      final map = complaint.toMap();
      expect(map['id'], 'AP-2026-0009');
      expect(map['user_id'], 101);
      expect(map['title'], 'Major pipeline rupture near market');
      expect(map['severity'], 'Critical');
      expect(map['status'], 'Pending');
    });

    test('Deserializes from map correctly', () {
      final map = complaint.toMap();
      final fromMap = ComplaintModel.fromMap(map);
      expect(fromMap.id, complaint.id);
      expect(fromMap.userId, complaint.userId);
      expect(fromMap.title, complaint.title);
      expect(fromMap.severity, 'Critical');
      expect(fromMap.isCritical, isTrue);
      expect(fromMap.isPending, isTrue);
      expect(fromMap.isResolved, isFalse);
    });

    test('copyWith updates specified attributes', () {
      final updated = complaint.copyWith(
        status: 'Resolved',
        resolutionDetails: 'Replaced pipe coupling.',
      );
      expect(updated.status, 'Resolved');
      expect(updated.isResolved, isTrue);
      expect(updated.isPending, isFalse);
      expect(updated.resolutionDetails, 'Replaced pipe coupling.');
      expect(updated.id, complaint.id); // preserved
    });
  });
}
