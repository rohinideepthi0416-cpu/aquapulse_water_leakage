import 'package:flutter/material.dart';
import '../../models/complaint_model.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/severity_badge.dart';
import '../../widgets/responsive_layout.dart';
import 'complaint_details_screen.dart';

class ComplaintSuccessScreen extends StatelessWidget {
  final ComplaintModel complaint;

  const ComplaintSuccessScreen({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paleAqua,
      body: SafeArea(
        child: ResponsiveContentWrapper(
          maxWidth: 540,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.mintGreenLight,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.mintGreen,
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          Icons.check_circle_rounded,
                          size: 64,
                          color: AppColors.mintGreen,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Complaint Submitted!',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Your water leakage complaint has been logged and assigned to the municipal ward engineering cell.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textMuted,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.textDark.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Complaint ID',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textLight,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryTealLight,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        complaint.id,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryTealDark,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24, color: AppColors.divider),
                            Row(
                              children: [
                                const Text(
                                  'Category',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textLight,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    complaint.leakageType,
                                    textAlign: TextAlign.end,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              runSpacing: 8,
                              children: [
                                const Text(
                                  'Priority & Status',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textLight,
                                  ),
                                ),
                                Wrap(
                                  spacing: 8,
                                  children: [
                                    SeverityBadge(severity: complaint.severity),
                                    StatusBadge(status: complaint.status),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),
                      AppButton(
                        text: 'Track Complaint Progress',
                        icon: Icons.track_changes_rounded,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ComplaintDetailsScreen(complaint: complaint),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.userDashboard,
                            (route) => false,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Return to Home Dashboard'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
