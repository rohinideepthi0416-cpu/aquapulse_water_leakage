import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/date_formatter.dart';
import 'app_card.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;
    final isResolved = notification.title.toLowerCase().contains('resolved');

    return AppCard(
      onTap: onTap,
      color: isUnread ? AppColors.softSurface : AppColors.surfaceWhite,
      border: isUnread
          ? Border.all(
              color: AppColors.primaryTeal.withValues(alpha: 0.35),
              width: 1.2,
            )
          : null,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (isResolved ? AppColors.mintGreen : AppColors.primaryTeal)
                  .withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isResolved
                  ? Icons.check_circle_rounded
                  : Icons.notifications_active_rounded,
              color: isResolved ? AppColors.mintGreen : AppColors.primaryTeal,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isUnread
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.coralOrange,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  notification.message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTealLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        notification.complaintId,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTealDark,
                        ),
                      ),
                    ),
                    Text(
                      DateFormatter.timeAgo(
                        DateTime.tryParse(notification.createdAt) ??
                            DateTime.now(),
                      ),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
