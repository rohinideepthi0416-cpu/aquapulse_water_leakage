import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../providers/complaint_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/responsive_layout.dart';

class ProfileScreen extends StatelessWidget {
  final bool isTab;

  const ProfileScreen({super.key, this.isTab = false});

  void _showEditProfileDialog(BuildContext context, user) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: user.name);
    final phoneCtrl = TextEditingController(text: user.phone);
    final addrCtrl = TextEditingController(text: user.address);

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Update Profile Details'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  controller: nameCtrl,
                  label: 'Full Name',
                  validator: (val) => Validators.minLength(val, 3, 'Name'),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: phoneCtrl,
                  label: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: addrCtrl,
                  label: 'Address / Ward',
                  validator: (val) => Validators.required(val, 'Address'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final authProv = context.read<AuthProvider>();
                final success = await authProv.updateProfile(
                  name: nameCtrl.text,
                  phone: phoneCtrl.text,
                  address: addrCtrl.text,
                );
                if (dialogCtx.mounted) Navigator.pop(dialogCtx);
                if (context.mounted && success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully.'),
                      backgroundColor: AppColors.mintGreen,
                    ),
                  );
                }
              }
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Sign Out'),
        content: const Text('Are you sure you want to sign out of AquaPulse?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.redCritical,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<AuthProvider>().logout();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final complaintProv = context.watch<ComplaintProvider>();

    Widget body = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ResponsiveContentWrapper(
        maxWidth: 720,
        child: Column(
          children: [
            // User Avatar Card
            AppCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.primaryTeal,
                    child: Text(
                      user != null && user.name.isNotEmpty
                          ? user.name[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    user?.name ?? 'Citizen User',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: user?.isAdmin == true
                          ? AppColors.violetLight
                          : AppColors.primaryTealLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user?.isAdmin == true
                          ? 'Department Administrator'
                          : 'Registered Citizen',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: user?.isAdmin == true
                            ? AppColors.violetAccent
                            : AppColors.primaryTealDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: user == null
                        ? null
                        : () => _showEditProfileDialog(context, user),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit Details'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Profile Information List
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoTile(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: user?.email ?? 'Not provided',
                  ),
                  const Divider(height: 16, color: AppColors.divider),
                  _buildInfoTile(
                    icon: Icons.phone_outlined,
                    label: 'Mobile',
                    value: user?.phone ?? 'Not provided',
                  ),
                  const Divider(height: 16, color: AppColors.divider),
                  _buildInfoTile(
                    icon: Icons.location_on_outlined,
                    label: 'Address',
                    value: user?.address ?? 'Not provided',
                  ),
                  const Divider(height: 16, color: AppColors.divider),
                  _buildInfoTile(
                    icon: Icons.assignment_turned_in_outlined,
                    label: 'Complaints Logged',
                    value:
                        '${complaintProv.userTotalCount} Total '
                        '(${complaintProv.userResolvedCount} Resolved)',
                  ),
                ],
              ),
            ),

            // Security & Architecture Info Box (College Viva / Practical Documentation)
            AppCard(
              color: AppColors.paleAqua,
              padding: const EdgeInsets.all(16),
              border: Border.all(
                color: AppColors.primaryTeal.withValues(alpha: 0.3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.security_rounded,
                        color: AppColors.primaryTeal,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Security & Architecture Note',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryTealDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Passwords are encrypted using SHA-256 with user-specific cryptographic salts.\n'
                    '• Local database storage is powered by SQLite with parameterized queries.\n'
                    '• Web/Chrome execution uses an automated memory adapter without native crashes.\n'
                    '• Multi-device production sync requires a central authenticated cloud backend (Firebase / REST).',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppButton(
                text: 'Sign Out of AquaPulse',
                icon: Icons.logout_rounded,
                variant: AppButtonVariant.danger,
                onPressed: () => _handleLogout(context),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );

    if (isTab) {
      return body;
    }

    return Scaffold(
      backgroundColor: AppColors.paleAqua,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppColors.primaryTeal,
      ),
      body: body,
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primaryTeal),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
