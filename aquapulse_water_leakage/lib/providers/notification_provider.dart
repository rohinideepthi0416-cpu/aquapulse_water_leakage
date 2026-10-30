import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../repositories/notification_repository.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _notificationRepository;

  List<NotificationModel> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;

  NotificationProvider({NotificationRepository? notificationRepository})
    : _notificationRepository =
          notificationRepository ?? NotificationRepository();

  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;

  /// Load user notifications and compute unread badge count
  Future<void> loadNotifications(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _notifications = await _notificationRepository.getUserNotifications(
        userId,
      );
      _unreadCount = await _notificationRepository.getUnreadCount(userId);
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  /// Mark single notification as read
  Future<void> markAsRead(int notificationId, int userId) async {
    try {
      await _notificationRepository.markNotificationAsRead(notificationId);
      final idx = _notifications.indexWhere((n) => n.id == notificationId);
      if (idx != -1) {
        _notifications[idx] = _notifications[idx].copyWith(isRead: true);
        if (_unreadCount > 0) _unreadCount--;
        notifyListeners();
      }
    } catch (_) {}
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead(int userId) async {
    try {
      await _notificationRepository.markAllAsRead(userId);
      _notifications = _notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();
      _unreadCount = 0;
      notifyListeners();
    } catch (_) {}
  }
}
