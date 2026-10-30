import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/complaint_model.dart';
import '../../models/complaint_history_model.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../providers/auth_provider.dart';
import '../../providers/complaint_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/severity_badge.dart';
import '../../widgets/progress_tracker.dart';
import '../../widgets/app_card.dart';
import '../../widgets/responsive_layout.dart';

class AdminComplaintDetailsScreen extends StatefulWidget {
  final ComplaintModel? complaint;

  const AdminComplaintDetailsScreen({super.key, this.complaint});

  @override
  State<AdminComplaintDetailsScreen> createState() =>
      _AdminComplaintDetailsScreenState();
}

class _AdminComplaintDetailsScreenState
    extends State<AdminComplaintDetailsScreen> {
  ComplaintModel? _complaint;
  List<ComplaintHistoryModel> _history = [];
  bool _isLoadingHistory = true;

  // Status Update Form State
  String _targetStatus = AppConstants.statusInProgress;
  final _remarksController = TextEditingController();
  final _resolutionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _complaint = widget.complaint;
    if (_complaint != null) {
      _targetStatus = _complaint!.status == AppConstants.statusResolved
          ? AppConstants.statusResolved
          : AppConstants.statusInProgress;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_complaint == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is ComplaintModel) {
        _complaint = args;
        _targetStatus = _complaint!.status == AppConstants.statusResolved
            ? AppConstants.statusResolved
            : AppConstants.statusInProgress;
      }
    }
    if (_complaint != null && _history.isEmpty) {
      _loadHistory();
    }
  }

  @override
  void dispose() {
    _remarksController.dispose();
    _resolutionController.dispose();
    super.dispose();
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

  Future<void> _handleStatusUpdate() async {
    if (_remarksController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter administrative remarks for this update.'),
          backgroundColor: AppColors.redCritical,
        ),
      );
      return;
    }

    if (_targetStatus == AppConstants.statusResolved &&
        _resolutionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Resolution details are mandatory when marking complaint Resolved.',
          ),
          backgroundColor: AppColors.redCritical,
        ),
      );
      return;
    }

    final adminUser = context.read<AuthProvider>().currentUser;
    final complaintProv = context.read<ComplaintProvider>();

    final success = await complaintProv.updateStatus(
      complaintId: _complaint!.id,
      newStatus: _targetStatus,
      remarks: _remarksController.text,
      adminName: adminUser?.name ?? 'Municipal Officer',
      resolutionDetails: _targetStatus == AppConstants.statusResolved
          ? _resolutionController.text
          : null,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Complaint ${_complaint!.id} updated to "$_targetStatus". In-app notification sent to citizen.',
          ),
          backgroundColor: AppColors.mintGreen,
        ),
      );

      // Refresh local complaint state
      final updated = await complaintProv.getComplaintById(_complaint!.id);
      if (mounted && updated != null) {
        setState(() {
          _complaint = updated;
          _remarksController.clear();
          _resolutionController.clear();
        });
        _loadHistory();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_complaint == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Admin Review')),
        body: const Center(child: Text('Complaint not found')),
      );
    }

    final c = _complaint!;

    return Scaffold(
      backgroundColor: AppColors.paleAqua,
      appBar: AppBar(
        title: Text(
          'Admin Review: ${c.id}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: AppColors.violetAccent,
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
                      'Resolution Workflow',
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

              // Complainant & Incident Details
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
                            color: AppColors.violetAccent,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SeverityBadge(severity: c.severity),
                        StatusBadge(status: c.status),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      c.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const Divider(height: 20, color: AppColors.divider),

                    // Citizen Details Box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.violetLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person_pin_circle_rounded,
                            color: AppColors.violetAccent,
                            size: 26,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Complainant: ${c.userName ?? "Citizen"}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                Text(
                                  'Contact: ${c.userPhone ?? "Not registered"}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildDetailRow(
                      icon: Icons.category_outlined,
                      label: 'Leakage Type',
                      value: c.leakageType,
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
                    _buildDetailRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Submitted At',
                      value: DateFormatter.formatIso(c.createdAt),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Citizen Description',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      c.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                        height: 1.4,
                      ),
                    ),
                    if (c.imagePath != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Attached Proof: ${c.imagePath}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Existing Resolution Report Box (if resolved)
              if (c.isResolved)
                AppCard(
                  color: AppColors.mintGreenLight,
                  border: Border.all(
                    color: AppColors.mintGreen.withValues(alpha: 0.5),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Active Resolution Report',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00695C),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        c.resolutionDetails ?? 'Resolved.',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF004D40),
                        ),
                      ),
                    ],
                  ),
                ),

              // Management Action Panel (Update Status)
              AppCard(
                border: Border.all(
                  color: AppColors.violetAccent.withValues(alpha: 0.35),
                  width: 1.2,
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.edit_note_rounded,
                          color: AppColors.violetAccent,
                          size: 22,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Update Complaint Status & Dispatch',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Target Status Radio/Choice Chips
                    const Text(
                      'Select New Status',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children:
                          [
                            AppConstants.statusReviewed,
                            AppConstants.statusInProgress,
                            AppConstants.statusResolved,
                          ].map((status) {
                            final isSelected = _targetStatus == status;
                            final color = AppColors.statusColor(status);
                            return ChoiceChip(
                              label: Text(status),
                              selected: isSelected,
                              selectedColor: color,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : color,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              onSelected: (val) {
                                if (val) {
                                  setState(() {
                                    _targetStatus = status;
                                  });
                                }
                              },
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Remarks Field
                    AppTextField(
                      controller: _remarksController,
                      label: 'Administrative Remarks / Action Log *',
                      hint:
                          'e.g. Field crew dispatched with heavy pump & repair sleeve.',
                      prefixIcon: Icons.comment_outlined,
                      maxLines: 2,
                    ),

                    // Resolution Details Field (shown if target is Resolved)
                    if (_targetStatus == AppConstants.statusResolved) ...[
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: _resolutionController,
                        label: 'Resolution Details *',
                        hint:
                            'e.g. Replaced damaged 6-inch GI pipe joint and verified zero leak.',
                        prefixIcon: Icons.verified_outlined,
                        maxLines: 3,
                      ),
                    ],
                    const SizedBox(height: 20),

                    // Submit Update Button
                    AppButton(
                      text: 'Apply Status Update & Notify Citizen',
                      icon: Icons.notification_add_rounded,
                      variant: AppButtonVariant.secondary,
                      isLoading: context.watch<ComplaintProvider>().isLoading,
                      onPressed: _handleStatusUpdate,
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
                    const Text(
                      'Complete Transition Audit Log',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (_isLoadingHistory)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (_history.isEmpty)
                      const Text(
                        'No history logged yet.',
                        style: TextStyle(color: AppColors.textLight),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _history.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 18, color: AppColors.divider),
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
                                    const SizedBox(height: 4),
                                    Text(
                                      item.remarks,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Officer: ${item.updatedByName}',
                                      style: const TextStyle(
                                        fontSize: 11,
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
              const SizedBox(height: 32),
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
