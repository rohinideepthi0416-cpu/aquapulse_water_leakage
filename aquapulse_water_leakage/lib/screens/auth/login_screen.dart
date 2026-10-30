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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillDemoCitizen() {
    _emailController.text = AppConstants.demoUserEmail;
    _passwordController.text = AppConstants.demoUserPassword;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      if (authProvider.isAdmin) {
        Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.userDashboard);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Authentication failed'),
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
                  const SizedBox(height: 24),
                  // App Icon Header
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryTeal.withValues(
                              alpha: 0.25,
                            ),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.water_drop_rounded,
                        size: 46,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome to AquaPulse',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Sign in to report water leakages & track resolutions',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 28),

                  // Quick Demo Autofill Pill
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTealLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryTeal.withValues(alpha: 0.3),
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
                                'Practical Evaluation Demo',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: AppColors.primaryTealDark,
                                ),
                              ),
                              Text(
                                'Tap to auto-fill sample citizen credentials',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _fillDemoCitizen,
                          icon: const Icon(Icons.flash_on, size: 16),
                          label: const Text('Auto-Fill'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primaryTealDark,
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
                    label: 'Email Address',
                    hint: 'name@example.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: '••••••••',
                    prefixIcon: Icons.lock_outline_rounded,
                    isPassword: true,
                    validator: (val) => Validators.required(val, 'Password'),
                  ),
                  const SizedBox(height: 24),

                  AppButton(
                    text: 'Sign In',
                    icon: Icons.login_rounded,
                    isLoading: authProvider.isLoading,
                    onPressed: _handleLogin,
                  ),
                  const SizedBox(height: 20),

                  // Register Link
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                        child: const Text(
                          'Register Here',
                          style: TextStyle(
                            color: AppColors.primaryTeal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Divider
                  const Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.divider)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'OFFICIAL ACCESS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.divider)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Admin Portal Button
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.adminLogin);
                    },
                    icon: const Icon(
                      Icons.admin_panel_settings_outlined,
                      color: AppColors.violetAccent,
                    ),
                    label: const Text(
                      'Department Official / Admin Portal',
                      style: TextStyle(color: AppColors.violetAccent),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.violetAccent,
                        width: 1.2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
