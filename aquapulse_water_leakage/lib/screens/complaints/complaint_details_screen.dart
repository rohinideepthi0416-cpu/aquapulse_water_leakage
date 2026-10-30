import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/complaint_model.dart';
import '../../models/complaint_history_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../providers/complaint_provider.dart';
import '../../widgets/progress_tracker.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/severity_badge.dart';
import '../../widgets/app_card.dart';
import '../../widgets/responsive_layout.dart';

class ComplaintDetailsScreen extends StatefulWidget {
  final ComplaintModel? complaint;

  const ComplaintDetailsScreen({super.key, this.complaint});

  @override
  State<ComplaintDetailsScreen> createState() => _ComplaintDetailsScreenState();
}

class _ComplaintDetailsScreenState extends State<ComplaintDetailsScreen> {
  ComplaintModel? _complaint;
  List<ComplaintHistoryModel> _history = [];
  bool _isLoadingHistory = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_complaint == null) {
      if (widget.complaint != null) {
        _complaint = widget.complaint;
      } else {
        final args = ModalRoute.of(context)?.settings.arguments;
        if (args is ComplaintModel) {
          _complaint = args;
        }
      }
      if (_complaint != null) {
        _loadHistory();
      }
    }
  }

  Future<void> _loadHistory() async {
    if (_complaint == null) return;
    setState(() => _isLoadingHistory = true);
    final history = await context.read<ComplaintProvider>().getComplaintHistory(
      _complaint!.id,
    );
    if (mounted) {
      setState(() {
        _history = history;
        _isLoadingHistory = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_complaint == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Complaint Details')),
        body: const Center(child: Text('Complaint not found')),
      );
    }

    final c = _complaint!;

    return Scaffold(
      backgroundColor: AppColors.paleAqua,
      appBar: AppBar(
        title: Text('Complaint ${c.id}'),
        backgroundColor: AppColors.primaryTeal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: ResponsiveContentWrapper(
          maxWidth: 760,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Tracker Card
              AppCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Resolution Lifecycle Tracker',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ProgressTracker(currentStatus: c.status),
                  ],
                ),
              ),

              // Primary Overview Card
              AppCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          c.id,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryTeal,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SeverityBadge(severity: c.severity),
                        StatusBadge(status: c.status),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      c.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildDetailRow(
                      icon: Icons.category_outlined,
                      label: 'Category',
                      value: c.leakageType,
                    ),
                    _buildDetailRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Reported On',
                      value: DateFormatter.formatIso(c.createdAt),
                    ),
                    _buildDetailRow(
                      icon: Icons.location_on_outlined,
                      label: 'Location',
                      value: c.location,
                    ),
                    _buildDetailRow(
                      icon: Icons.near_me_outlined,
                      label: 'Landmark',
                      value: c.landmark,
                    ),
                    const Divider(height: 24, color: AppColors.divider),
                    const Text(
                      'Detailed Description',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      c.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                        height: 1.45,
                      ),
                    ),
                    if (c.imagePath != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTealLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.attachment_rounded,
                              color: AppColors.primaryTeal,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Attachment: ${c.imagePath}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryTealDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Resolution Details Highlight Box
              if (c.isResolved)
                AppCard(
                  color: AppColors.mintGreenLight,
                  border: Border.all(
                    color: AppColors.mintGreen.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            color: AppColors.mintGreen,
                            size: 22,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Official Resolution Report',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00695C),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        c.resolutionDetails ??
                            'Maintenance repair completed and verified by municipal inspection engineers.',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF004D40),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

              // Status Transition History Timeline
              AppCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.history_rounded,
                          color: AppColors.primaryTeal,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Status Change History',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_isLoadingHistory)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (_history.isEmpty)
                      const Text(
                        'No status changes recorded yet.',
                        style: TextStyle(color: AppColors.textLight),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _history.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 20, color: AppColors.divider),
                        itemBuilder: (context, index) {
                          final item = _history[index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: AppColors.statusColor(item.status),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        StatusBadge(status: item.status),
                                        Text(
                                          DateFormatter.formatIso(
                                            item.updatedAt,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item.remarks,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Updated by: ${item.updatedByName}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textLight),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
