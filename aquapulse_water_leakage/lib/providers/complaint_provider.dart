import 'package:flutter/material.dart';
import '../models/complaint_model.dart';
import '../models/complaint_history_model.dart';
import '../repositories/complaint_repository.dart';
import '../core/constants/app_constants.dart';

class ComplaintProvider extends ChangeNotifier {
  final ComplaintRepository _complaintRepository;

  List<ComplaintModel> _userComplaints = [];
  List<ComplaintModel> _adminComplaints = [];
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  // Active filters for My Complaints
  String _activeUserFilter = 'All'; // All, Pending, In Progress, Resolved

  // Active filters for Admin
  String _adminStatusFilter = 'All';
  String _adminSeverityFilter = 'All';
  String _adminSearchQuery = '';
  String _adminSortBy = 'newest';

  ComplaintProvider({ComplaintRepository? complaintRepository})
    : _complaintRepository = complaintRepository ?? ComplaintRepository();

  List<ComplaintModel> get userComplaints => _userComplaints;
  List<ComplaintModel> get adminComplaints => _adminComplaints;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  String get activeUserFilter => _activeUserFilter;
  String get adminStatusFilter => _adminStatusFilter;
  String get adminSeverityFilter => _adminSeverityFilter;
  String get adminSearchQuery => _adminSearchQuery;
  String get adminSortBy => _adminSortBy;

  // Filtered User Complaints
  List<ComplaintModel> get filteredUserComplaints {
    if (_activeUserFilter == 'All') return _userComplaints;
    return _userComplaints
        .where((c) => c.status.toLowerCase() == _activeUserFilter.toLowerCase())
        .toList();
  }

  // Statistics for Current User
  int get userTotalCount => _userComplaints.length;
  int get userPendingCount => _userComplaints
      .where((c) => c.status == AppConstants.statusPending)
      .length;
  int get userInProgressCount => _userComplaints
      .where((c) => c.status == AppConstants.statusInProgress)
      .length;
  int get userResolvedCount => _userComplaints
      .where((c) => c.status == AppConstants.statusResolved)
      .length;

  // Statistics for Admin Dashboard
  int get adminTotalCount => _adminComplaints.length;
  int get adminPendingCount => _adminComplaints
      .where((c) => c.status == AppConstants.statusPending)
      .length;
  int get adminInProgressCount => _adminComplaints
      .where((c) => c.status == AppConstants.statusInProgress)
      .length;
  int get adminResolvedCount => _adminComplaints
      .where((c) => c.status == AppConstants.statusResolved)
      .length;
  int get adminHighPriorityCount =>
      _adminComplaints.where((c) => c.severity == 'High').length;
  int get adminCriticalCount =>
      _adminComplaints.where((c) => c.severity == 'Critical').length;

  void setUserFilter(String filter) {
    _activeUserFilter = filter;
    notifyListeners();
  }

  void setAdminFilters({
    String? status,
    String? severity,
    String? query,
    String? sortBy,
  }) {
    if (status != null) _adminStatusFilter = status;
    if (severity != null) _adminSeverityFilter = severity;
    if (query != null) _adminSearchQuery = query;
    if (sortBy != null) _adminSortBy = sortBy;
    loadAdminComplaints();
  }

  /// Load complaints for a specific user
  Future<void> loadUserComplaints(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userComplaints = await _complaintRepository.getUserComplaints(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load all complaints for admin
  Future<void> loadAdminComplaints() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _adminComplaints = await _complaintRepository.getAllComplaintsForAdmin(
        searchQuery: _adminSearchQuery,
        statusFilter: _adminStatusFilter,
        severityFilter: _adminSeverityFilter,
        sortBy: _adminSortBy,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Submit a new water leakage complaint
  Future<ComplaintModel?> submitComplaint({
    required int userId,
    required String userName,
    required String userPhone,
    required String title,
    required String description,
    required String leakageType,
    required String location,
    required String landmark,
    required String severity,
    String? imagePath,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final complaintId = await _complaintRepository
          .generateUniqueComplaintId();
      final now = DateTime.now().toIso8601String();

      final complaint = ComplaintModel(
        id: complaintId,
        userId: userId,
        userName: userName,
        userPhone: userPhone,
        title: title.trim(),
        description: description.trim(),
        leakageType: leakageType,
        location: location.trim(),
        landmark: landmark.trim(),
        severity: severity,
        status: AppConstants.statusPending,
        createdAt: now,
        updatedAt: now,
        imagePath: imagePath,
      );

      final created = await _complaintRepository.createComplaint(complaint);
      _userComplaints.insert(0, created);

      _isSubmitting = false;
      notifyListeners();
      return created;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isSubmitting = false;
      notifyListeners();
      return null;
    }
  }

  /// Update complaint status by admin
  Future<bool> updateStatus({
    required String complaintId,
    required String newStatus,
    required String remarks,
    required String adminName,
    String? resolutionDetails,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _complaintRepository.updateComplaintStatus(
        complaintId: complaintId,
        newStatus: newStatus,
        remarks: remarks,
        adminName: adminName,
        resolutionDetails: resolutionDetails,
      );

      // Refresh admin list to update counts and state immediately
      await loadAdminComplaints();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Fetch history records for a complaint
  Future<List<ComplaintHistoryModel>> getComplaintHistory(
    String complaintId,
  ) async {
    return await _complaintRepository.getComplaintHistory(complaintId);
  }

  /// Fetch single complaint details
  Future<ComplaintModel?> getComplaintById(String complaintId) async {
    return await _complaintRepository.getComplaintById(complaintId);
  }
}
