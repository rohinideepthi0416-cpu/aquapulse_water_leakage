import '../database/app_database.dart';
import '../models/complaint_model.dart';
import '../models/complaint_history_model.dart';
import '../models/notification_model.dart';
import '../core/constants/app_constants.dart';

class ComplaintRepository {
  final AppDatabase _dbInstance;

  ComplaintRepository({AppDatabase? dbInstance})
    : _dbInstance = dbInstance ?? AppDatabase();

  /// Generate a unique, formatted complaint ID (e.g. AP-2026-0003)
  Future<String> generateUniqueComplaintId() async {
    final adapter = _dbInstance.adapter;
    final all = await adapter.query('complaints');
    final year = DateTime.now().year;
    final nextNum = all.length + 1;
    final formattedNum = nextNum.toString().padLeft(4, '0');
    return 'AP-$year-$formattedNum';
  }

  /// Create a new complaint and add initial history log
  Future<ComplaintModel> createComplaint(ComplaintModel complaint) async {
    final adapter = _dbInstance.adapter;
    final now = DateTime.now().toIso8601String();

    await adapter.insert('complaints', complaint.toMap());

    // Record initial history
    final history = ComplaintHistoryModel(
      complaintId: complaint.id,
      status: AppConstants.statusPending,
      remarks: 'Complaint logged by citizen.',
      updatedByName: complaint.userName ?? 'Citizen',
      updatedAt: now,
    );
    await adapter.insert('complaint_status_history', history.toMap());

    return complaint;
  }

  /// Fetch complaints belonging ONLY to the logged-in citizen
  Future<List<ComplaintModel>> getUserComplaints(int userId) async {
    final adapter = _dbInstance.adapter;
    final results = await adapter.query(
      'complaints',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return results.map((map) => ComplaintModel.fromMap(map)).toList();
  }

  /// Fetch ALL complaints for Admin view with search and filters
  Future<List<ComplaintModel>> getAllComplaintsForAdmin({
    String? searchQuery,
    String? statusFilter,
    String? severityFilter,
    String sortBy = 'newest', // 'newest', 'oldest', 'priority'
  }) async {
    final adapter = _dbInstance.adapter;
    final results = await adapter.query('complaints');
    var list = results.map((map) => ComplaintModel.fromMap(map)).toList();

    // Search query filter (matches ID, title, or location)
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase().trim();
      list = list.where((c) {
        return c.id.toLowerCase().contains(q) ||
            c.title.toLowerCase().contains(q) ||
            c.location.toLowerCase().contains(q) ||
            c.landmark.toLowerCase().contains(q) ||
            (c.userName?.toLowerCase().contains(q) ?? false);
      }).toList();
    }

    // Status filter
    if (statusFilter != null &&
        statusFilter.isNotEmpty &&
        statusFilter != 'All') {
      list = list.where((c) => c.status == statusFilter).toList();
    }

    // Severity filter
    if (severityFilter != null &&
        severityFilter.isNotEmpty &&
        severityFilter != 'All') {
      list = list.where((c) => c.severity == severityFilter).toList();
    }

    // Sorting
    if (sortBy == 'oldest') {
      list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } else if (sortBy == 'priority') {
      const priorityOrder = {'Critical': 4, 'High': 3, 'Medium': 2, 'Low': 1};
      list.sort((a, b) {
        final pA = priorityOrder[a.severity] ?? 0;
        final pB = priorityOrder[b.severity] ?? 0;
        return pB.compareTo(pA); // Highest priority first
      });
    } else {
      // Default: newest first
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return list;
  }

  /// Get specific complaint by ID
  Future<ComplaintModel?> getComplaintById(String id) async {
    final adapter = _dbInstance.adapter;
    final results = await adapter.query(
      'complaints',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isEmpty) return null;
    return ComplaintModel.fromMap(results.first);
  }

  /// Update complaint status by Admin:
  /// 1. Updates complaint status & resolution details
  /// 2. Records status change history
  /// 3. Automatically triggers an in-app notification for the citizen
  Future<void> updateComplaintStatus({
    required String complaintId,
    required String newStatus,
    required String remarks,
    required String adminName,
    String? resolutionDetails,
  }) async {
    final adapter = _dbInstance.adapter;
    final now = DateTime.now().toIso8601String();

    // 1. Fetch current complaint
    final complaint = await getComplaintById(complaintId);
    if (complaint == null) {
      throw Exception('Complaint $complaintId not found');
    }

    // 2. Update complaint table
    final updateData = <String, dynamic>{
      'status': newStatus,
      'updated_at': now,
    };
    if (resolutionDetails != null && resolutionDetails.trim().isNotEmpty) {
      updateData['resolution_details'] = resolutionDetails.trim();
    }
    await adapter.update(
      'complaints',
      updateData,
      where: 'id = ?',
      whereArgs: [complaintId],
    );

    // 3. Add to status history
    final history = ComplaintHistoryModel(
      complaintId: complaintId,
      status: newStatus,
      remarks: remarks.trim(),
      updatedByName: adminName,
      updatedAt: now,
    );
    await adapter.insert('complaint_status_history', history.toMap());

    // 4. Generate in-app notification for the citizen who filed it
    String notificationTitle = 'Update on Complaint $complaintId';
    String notificationMessage;
    if (newStatus == AppConstants.statusResolved) {
      notificationTitle = 'Complaint Resolved: $complaintId';
      notificationMessage =
          'Your complaint $complaintId has been resolved. Resolution: ${resolutionDetails ?? remarks}. Thank you for helping us save water!';
    } else if (newStatus == AppConstants.statusInProgress) {
      notificationTitle = 'Work In Progress: $complaintId';
      notificationMessage =
          'Your complaint $complaintId is now In Progress. Remarks: $remarks.';
    } else {
      notificationMessage =
          'Status of complaint $complaintId changed to $newStatus. Remarks: $remarks.';
    }

    final notification = NotificationModel(
      userId: complaint.userId,
      complaintId: complaintId,
      title: notificationTitle,
      message: notificationMessage,
      isRead: false,
      createdAt: now,
    );
    await adapter.insert('notifications', notification.toMap());
  }

  /// Get status transition history for a complaint
  Future<List<ComplaintHistoryModel>> getComplaintHistory(
    String complaintId,
  ) async {
    final adapter = _dbInstance.adapter;
    final results = await adapter.query(
      'complaint_status_history',
      where: 'complaint_id = ?',
      whereArgs: [complaintId],
      orderBy: 'updated_at ASC',
    );
    return results.map((m) => ComplaintHistoryModel.fromMap(m)).toList();
  }
}
