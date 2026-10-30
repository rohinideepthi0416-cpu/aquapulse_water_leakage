import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class ProgressTracker extends StatelessWidget {
  final String currentStatus;

  const ProgressTracker({super.key, required this.currentStatus});

  static const List<String> steps = [
    'Reported',
    'Reviewed',
    'In Progress',
    'Resolved',
  ];

  int _getStepIndex(String status) {
    switch (status.toLowerCase()) {
      case 'resolved':
        return 3;
      case 'in progress':
      case 'in_progress':
        return 2;
      case 'reviewed':
        return 1;
      case 'pending':
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getStepIndex(currentStatus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(steps.length * 2 - 1, (index) {
            // Even indexes are step circles, odd indexes are connecting lines
            if (index.isEven) {
              final stepIdx = index ~/ 2;
              final isCompleted = stepIdx <= currentIndex;
              final isCurrent = stepIdx == currentIndex;

              Color stepColor;
              if (isCompleted) {
                stepColor = (stepIdx == 3)
                    ? AppColors.mintGreen
                    : (stepIdx == 2
                          ? AppColors.violetAccent
                          : AppColors.primaryTeal);
              } else {
                stepColor = AppColors.borderLight;
              }

              return Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted ? stepColor : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCompleted ? stepColor : AppColors.borderLight,
                    width: 2,
                  ),
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: stepColor.withValues(alpha: 0.35),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, size: 18, color: Colors.white)
                      : Text(
                          '${stepIdx + 1}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMuted,
                          ),
                        ),
                ),
              );
            } else {
              // Connecting line
              final lineIdx = index ~/ 2;
              final isPassed = lineIdx < currentIndex;
              return Expanded(
                child: Container(
                  height: 3,
                  color: isPassed
                      ? AppColors.primaryTeal
                      : AppColors.borderLight.withValues(alpha: 0.6),
                ),
              );
            }
          }),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(steps.length, (index) {
            final isCurrent = index == currentIndex;
            final isCompleted = index <= currentIndex;
            return Expanded(
              child: Text(
                steps[index],
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                  color: isCompleted ? AppColors.textDark : AppColors.textLight,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
