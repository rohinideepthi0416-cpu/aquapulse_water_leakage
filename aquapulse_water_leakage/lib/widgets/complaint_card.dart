import 'package:flutter/material.dart';
import '../models/complaint_model.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/date_formatter.dart';
import 'status_badge.dart';
import 'severity_badge.dart';
import 'app_card.dart';

class ComplaintCard extends StatelessWidget {
  final ComplaintModel complaint;
  final VoidCallback onTap;
  final bool showUserInfo;

  const ComplaintCard({
    super.key,
    required this.complaint,
    required this.onTap,
    this.showUserInfo = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                complaint.id,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTeal,
                  letterSpacing: 0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SeverityBadge(severity: complaint.severity),
              StatusBadge(status: complaint.status),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            complaint.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 15,
                color: AppColors.coralOrange,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  complaint.location,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (showUserInfo && complaint.userName != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 15,
                  color: AppColors.violetAccent,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    complaint.userName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.violetAccent,
                    ),
                  ),
                ),
                if (complaint.userPhone != null) ...[
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '(${complaint.userPhone})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
          const Divider(height: 20, color: AppColors.divider),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.water_drop_outlined,
                      size: 14,
                      color: AppColors.turquoise,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        complaint.leakageType,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Updated ${DateFormatter.timeAgo(DateTime.tryParse(complaint.updatedAt) ?? DateTime.now())}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
