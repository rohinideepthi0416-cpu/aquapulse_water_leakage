import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color = AppColors.statusColor(status);
    IconData icon;

    switch (status.toLowerCase()) {
      case 'resolved':
        icon = Icons.check_circle_rounded;
        break;
      case 'in progress':
      case 'in_progress':
        icon = Icons.build_circle_rounded;
        break;
      case 'reviewed':
        icon = Icons.visibility_rounded;
        break;
      case 'pending':
      default:
        icon = Icons.hourglass_top_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
