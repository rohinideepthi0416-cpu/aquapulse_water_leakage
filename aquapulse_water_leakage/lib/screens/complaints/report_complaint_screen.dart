import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../providers/complaint_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/responsive_layout.dart';
import 'complaint_success_screen.dart';

class ReportComplaintScreen extends StatefulWidget {
  const ReportComplaintScreen({super.key});

  @override
  State<ReportComplaintScreen> createState() => _ReportComplaintScreenState();
}

class _ReportComplaintScreenState extends State<ReportComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _landmarkController = TextEditingController();

  String _selectedLeakageType = AppConstants.leakageTypes.first;
  String _selectedSeverity = 'Medium';
  DateTime _selectedDateTime = DateTime.now();
  String? _attachedPhotoName;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryTeal,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _simulatePhotoAttachment() {
    setState(() {
      _attachedPhotoName =
          'leakage_proof_${DateTime.now().millisecondsSinceEpoch}.jpg';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo attached successfully.'),
        backgroundColor: AppColors.primaryTeal,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = context.read<AuthProvider>().currentUser;
    if (user?.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to submit a complaint.')),
      );
      return;
    }

    final complaintProv = context.read<ComplaintProvider>();
    final created = await complaintProv.submitComplaint(
      userId: user!.id!,
      userName: user.name,
      userPhone: user.phone,
      title: _titleController.text,
      description: _descriptionController.text,
      leakageType: _selectedLeakageType,
      location: _locationController.text,
      landmark: _landmarkController.text,
      severity: _selectedSeverity,
      imagePath: _attachedPhotoName,
    );

    if (!mounted) return;

    if (created != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ComplaintSuccessScreen(complaint: created),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            complaintProv.errorMessage ??
                'Submission failed. Please try again.',
          ),
          backgroundColor: AppColors.redCritical,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final complaintProv = context.watch<ComplaintProvider>();

    return Scaffold(
      backgroundColor: AppColors.paleAqua,
      appBar: AppBar(
        title: const Text('Report Water Leakage'),
        backgroundColor: AppColors.primaryTeal,
      ),
      body: ResponsiveContentWrapper(
        maxWidth: 600,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header instruction card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTealLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryTeal.withValues(alpha: 0.25),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.primaryTeal,
                        size: 22,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Provide accurate location and severity details so maintenance crews can be dispatched quickly.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primaryTealDark,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Complaint Title
                AppTextField(
                  controller: _titleController,
                  label: 'Complaint Title *',
                  hint: 'e.g. Broken pipe gushing water near bus stop',
                  prefixIcon: Icons.title_rounded,
                  validator: (val) =>
                      Validators.minLength(val, 6, 'Complaint title'),
                ),
                const SizedBox(height: 18),

                // Leakage Type Dropdown
                const Text(
                  'Leakage Category *',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedLeakageType,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.category_outlined,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                  items: AppConstants.leakageTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(
                        type,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedLeakageType = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 18),

                // Severity Level Selector
                const Text(
                  'Severity Level *',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: AppConstants.severityLevels.map((lvl) {
                    final isSelected = _selectedSeverity == lvl;
                    final color = AppColors.severityColor(lvl);

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.5),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedSeverity = lvl;
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? color : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: color,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: color.withValues(alpha: 0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              lvl,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : color,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                // Location / Address
                AppTextField(
                  controller: _locationController,
                  label: 'Street / Area Location *',
                  hint: 'e.g. 5th Main Road, Indiranagar',
                  prefixIcon: Icons.location_on_outlined,
                  validator: (val) => Validators.required(val, 'Location'),
                ),
                const SizedBox(height: 18),

                // Landmark
                AppTextField(
                  controller: _landmarkController,
                  label: 'Landmark / Nearby Reference *',
                  hint: 'e.g. In front of Government School gate',
                  prefixIcon: Icons.near_me_outlined,
                  validator: (val) => Validators.required(val, 'Landmark'),
                ),
                const SizedBox(height: 18),

                // Date and Time Observed
                const Text(
                  'Date & Time Observed',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: _pickDateTime,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                color: AppColors.primaryTeal,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  DateFormatter.formatDateTime(
                                    _selectedDateTime,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.edit_calendar_rounded,
                          size: 18,
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Detailed Description
                AppTextField(
                  controller: _descriptionController,
                  label: 'Detailed Description *',
                  hint:
                      'Describe water volume, damage to road, approximate flow rate, or hazards...',
                  prefixIcon: Icons.description_outlined,
                  maxLines: 4,
                  validator: (val) =>
                      Validators.minLength(val, 10, 'Description'),
                ),
                const SizedBox(height: 18),

                // Photo Attachment Container
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              _attachedPhotoName != null
                                  ? Icons.image_rounded
                                  : Icons.add_a_photo_outlined,
                              color: _attachedPhotoName != null
                                  ? AppColors.mintGreen
                                  : AppColors.primaryTeal,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _attachedPhotoName ?? 'Attach Leak Photo',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  Text(
                                    _attachedPhotoName != null
                                        ? 'Attached • Ready for dispatch crew'
                                        : 'Optional photographic proof',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _simulatePhotoAttachment,
                        icon: Icon(
                          _attachedPhotoName != null
                              ? Icons.change_circle
                              : Icons.upload_file,
                          size: 16,
                        ),
                        label: Text(
                          _attachedPhotoName != null ? 'Change' : 'Attach',
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primaryTeal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Submit Button
                AppButton(
                  text: 'Submit Leakage Complaint',
                  icon: Icons.send_rounded,
                  isLoading: complaintProv.isSubmitting,
                  onPressed: _handleSubmit,
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
