class ComplaintHistoryModel {
  final int? id;
  final String complaintId;
  final String status;
  final String remarks;
  final String updatedByName;
  final String updatedAt;

  ComplaintHistoryModel({
    this.id,
    required this.complaintId,
    required this.status,
    required this.remarks,
    required this.updatedByName,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'complaint_id': complaintId,
      'status': status,
      'remarks': remarks,
      'updated_by_name': updatedByName,
      'updated_at': updatedAt,
    };
  }

  factory ComplaintHistoryModel.fromMap(Map<String, dynamic> map) {
    return ComplaintHistoryModel(
      id: map['id'] as int?,
      complaintId: map['complaint_id'] as String? ?? '',
      status: map['status'] as String? ?? '',
      remarks: map['remarks'] as String? ?? '',
      updatedByName: map['updated_by_name'] as String? ?? 'Admin',
      updatedAt: map['updated_at'] as String? ?? '',
    );
  }
}
