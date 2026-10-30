class NotificationModel {
  final int? id;
  final int userId;
  final String complaintId;
  final String title;
  final String message;
  final bool isRead;
  final String createdAt;

  NotificationModel({
    this.id,
    required this.userId,
    required this.complaintId,
    required this.title,
    required this.message,
    this.isRead = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'complaint_id': complaintId,
      'title': title,
      'message': message,
      'is_read': isRead ? 1 : 0,
      'created_at': createdAt,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      complaintId: map['complaint_id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      message: map['message'] as String? ?? '',
      isRead: (map['is_read'] as int? ?? 0) == 1,
      createdAt: map['created_at'] as String? ?? '',
    );
  }

  NotificationModel copyWith({
    int? id,
    int? userId,
    String? complaintId,
    String? title,
    String? message,
    bool? isRead,
    String? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      complaintId: complaintId ?? this.complaintId,
      title: title ?? this.title,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
