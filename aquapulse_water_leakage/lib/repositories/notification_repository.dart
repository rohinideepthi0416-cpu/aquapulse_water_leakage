import '../database/app_database.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final AppDatabase _dbInstance;

  NotificationRepository({AppDatabase? dbInstance})
    : _dbInstance = dbInstance ?? AppDatabase();

  /// Retrieve notifications for a specific user
  Future<List<NotificationModel>> getUserNotifications(int userId) async {
    final adapter = _dbInstance.adapter;
    final results = await adapter.query(
      'notifications',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return results.map((m) => NotificationModel.fromMap(m)).toList();
  }

  /// Mark single notification as read
  Future<void> markNotificationAsRead(int notificationId) async {
    final adapter = _dbInstance.adapter;
    await adapter.update(
      'notifications',
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [notificationId],
    );
  }

  /// Mark all notifications as read for a user
  Future<void> markAllAsRead(int userId) async {
    final adapter = _dbInstance.adapter;
    await adapter.update(
      'notifications',
      {'is_read': 1},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  /// Get count of unread notifications
  Future<int> getUnreadCount(int userId) async {
    final adapter = _dbInstance.adapter;
    final results = await adapter.query(
      'notifications',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return results.where((r) => (r['is_read'] as int? ?? 0) == 0).length;
  }
}
