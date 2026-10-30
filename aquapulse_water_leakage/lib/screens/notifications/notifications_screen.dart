import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/complaint_provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/notification_card.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/responsive_layout.dart';

class NotificationsScreen extends StatefulWidget {
  final bool isTab;

  const NotificationsScreen({super.key, this.isTab = false});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;
      if (user?.id != null) {
        context.read<NotificationProvider>().loadNotifications(user!.id!);
      }
    });
  }

  Future<void> _handleNotificationTap(notification) async {
    final user = context.read<AuthProvider>().currentUser;
    if (user?.id != null && !notification.isRead && notification.id != null) {
      await context.read<NotificationProvider>().markAsRead(
        notification.id!,
        user!.id!,
      );
    }

    if (!mounted) return;

    // Fetch complaint and navigate to details
    final complaint = await context.read<ComplaintProvider>().getComplaintById(
      notification.complaintId,
    );

    if (mounted && complaint != null) {
      Navigator.pushNamed(
        context,
        AppRoutes.complaintDetails,
        arguments: complaint,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final notifProv = context.watch<NotificationProvider>();
    final notifications = notifProv.notifications;

    Widget body = Column(
      children: [
        if (notifications.isNotEmpty)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${notifProv.unreadCount} Unread Alerts',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                  ),
                ),
                if (notifProv.unreadCount > 0 && user?.id != null)
                  TextButton.icon(
                    onPressed: () {
                      notifProv.markAllAsRead(user!.id!);
                    },
                    icon: const Icon(Icons.done_all_rounded, size: 16),
                    label: const Text('Mark all as read'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primaryTeal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
              ],
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              if (user?.id != null) {
                await notifProv.loadNotifications(user!.id!);
              }
            },
            child: notifProv.isLoading
                ? const Center(child: CircularProgressIndicator())
                : notifications.isEmpty
                ? const EmptyStateView(
                    title: 'No Notifications Yet',
                    message:
                        'You will receive automatic alerts here when an engineer updates the status or resolves your complaints.',
                    icon: Icons.notifications_none_rounded,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final n = notifications[index];
                      return ResponsiveContentWrapper(
                        maxWidth: 760,
                        child: NotificationCard(
                          notification: n,
                          onTap: () => _handleNotificationTap(n),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );

    if (widget.isTab) {
      return body;
    }

    return Scaffold(
      backgroundColor: AppColors.paleAqua,
      appBar: AppBar(
        title: const Text('In-App Notifications'),
        backgroundColor: AppColors.primaryTeal,
      ),
      body: body,
    );
  }
}
