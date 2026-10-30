import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'app_button.dart';

class ErrorStateView extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;

  const ErrorStateView({
    super.key,
    this.title = 'Something went wrong',
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.redLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 44,
                color: AppColors.redCritical,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            AppButton(
              text: 'Try Again',
              icon: Icons.refresh_rounded,
              onPressed: onRetry,
              width: 160,
              height: 44,
            ),
          ],
        ),
      ),
    );
  }
}
