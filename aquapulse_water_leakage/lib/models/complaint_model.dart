class ComplaintModel {
  final String id; // e.g. AP-2026-0001
  final int userId;
  final String? userName;
  final String? userPhone;
  final String title;
  final String description;
  final String leakageType;
  final String location;
  final String landmark;
  final String severity; // Low, Medium, High, Critical
  final String status; // Pending, Reviewed, In Progress, Resolved
  final String createdAt;
  final String updatedAt;
  final String? resolutionDetails;
  final String? imagePath;

  ComplaintModel({
    required this.id,
    required this.userId,
    this.userName,
    this.userPhone,
    required this.title,
    required this.description,
    required this.leakageType,
    required this.location,
    required this.landmark,
    required this.severity,
    this.status = 'Pending',
    required this.createdAt,
    required this.updatedAt,
    this.resolutionDetails,
    this.imagePath,
  });

  bool get isResolved => status.toLowerCase() == 'resolved';
  bool get isInProgress => status.toLowerCase() == 'in progress';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isCritical => severity.toLowerCase() == 'critical';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'user_phone': userPhone,
      'title': title,
      'description': description,
      'leakage_type': leakageType,
      'location': location,
      'landmark': landmark,
      'severity': severity,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'resolution_details': resolutionDetails,
      'image_path': imagePath,
    };
  }

  factory ComplaintModel.fromMap(Map<String, dynamic> map) {
    return ComplaintModel(
      id: map['id'] as String,
      userId: map['user_id'] as int,
      userName: map['user_name'] as String?,
      userPhone: map['user_phone'] as String?,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      leakageType: map['leakage_type'] as String? ?? 'Pipeline Leak',
      location: map['location'] as String? ?? '',
      landmark: map['landmark'] as String? ?? '',
      severity: map['severity'] as String? ?? 'Medium',
      status: map['status'] as String? ?? 'Pending',
      createdAt: map['created_at'] as String? ?? '',
      updatedAt: map['updated_at'] as String? ?? '',
      resolutionDetails: map['resolution_details'] as String?,
      imagePath: map['image_path'] as String?,
    );
  }

  ComplaintModel copyWith({
    String? id,
    int? userId,
    String? userName,
    String? userPhone,
    String? title,
    String? description,
    String? leakageType,
    String? location,
    String? landmark,
    String? severity,
    String? status,
    String? createdAt,
    String? updatedAt,
    String? resolutionDetails,
    String? imagePath,
  }) {
    return ComplaintModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      title: title ?? this.title,
      description: description ?? this.description,
      leakageType: leakageType ?? this.leakageType,
      location: location ?? this.location,
      landmark: landmark ?? this.landmark,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolutionDetails: resolutionDetails ?? this.resolutionDetails,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
