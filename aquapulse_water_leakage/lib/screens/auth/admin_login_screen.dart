import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/responsive_layout.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillDemoAdmin() {
    _emailController.text = AppConstants.demoAdminEmail;
    _passwordController.text = AppConstants.demoAdminPassword;
  }

  Future<void> _handleAdminLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      email: _emailController.text,
      password: _passwordController.text,
      requiredRole: AppConstants.roleAdmin,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.adminDashboard,
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.errorMessage ??
                'Access Denied. Administrative credentials required.',
          ),
          backgroundColor: AppColors.redCritical,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.paleAqua,
      appBar: AppBar(
        title: const Text('Administrative Access'),
        backgroundColor: AppColors.violetAccent,
      ),
      body: SafeArea(
        child: ResponsiveContentWrapper(
          maxWidth: 520,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.violetAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.violetAccent.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        size: 46,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Department Official Portal',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Authorized water board officers and field managers only',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 24),

                  // Demo Autofill Banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.violetLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.violetAccent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Evaluator / Admin Demo',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: AppColors.violetAccent,
                                ),
                              ),
                              Text(
                                'Auto-fills municipal officer account',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _fillDemoAdmin,
                          icon: const Icon(Icons.flash_on, size: 16),
                          label: const Text('Auto-Fill'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.violetAccent,
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  AppTextField(
                    controller: _emailController,
                    label: 'Admin Email',
                    hint: 'admin@aquapulse.org',
                    prefixIcon: Icons.admin_panel_settings_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _passwordController,
                    label: 'Security Password',
                    hint: '••••••••',
                    prefixIcon: Icons.lock_outline_rounded,
                    isPassword: true,
                    validator: (val) =>
                        Validators.required(val, 'Admin password'),
                  ),
                  const SizedBox(height: 24),

                  AppButton(
                    text: 'Authenticate Official',
                    icon: Icons.verified_user_rounded,
                    variant: AppButtonVariant.secondary,
                    isLoading: authProvider.isLoading,
                    onPressed: _handleAdminLogin,
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded, size: 18),
                      label: const Text('Back to Citizen Sign In'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
