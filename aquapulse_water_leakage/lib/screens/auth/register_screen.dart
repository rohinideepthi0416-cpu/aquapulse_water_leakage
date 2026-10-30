import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/responsive_layout.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
      address: _addressController.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully! Welcome to AquaPulse.'),
          backgroundColor: AppColors.mintGreen,
        ),
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.userDashboard,
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.errorMessage ?? 'Registration failed. Try again.',
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
        title: const Text('Create Citizen Account'),
        backgroundColor: AppColors.primaryTeal,
      ),
      body: SafeArea(
        child: ResponsiveContentWrapper(
          maxWidth: 600,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    'Join the AquaPulse Community',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Register to report water leaks in your locality and help municipal engineers take fast action.',
                    style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 24),

                  AppTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    prefixIcon: Icons.person_outline,
                    validator: (val) =>
                        Validators.minLength(val, 3, 'Full name'),
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    hint: 'citizen@example.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _phoneController,
                    label: 'Mobile Number',
                    hint: '10-digit mobile number',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: Validators.phone,
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _addressController,
                    label: 'Address / Locality',
                    hint: 'Ward / Street / Building details',
                    prefixIcon: Icons.location_on_outlined,
                    validator: (val) => Validators.required(val, 'Address'),
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Minimum 6 characters',
                    prefixIcon: Icons.lock_outline_rounded,
                    isPassword: true,
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    hint: 'Re-enter your password',
                    prefixIcon: Icons.lock_reset_rounded,
                    isPassword: true,
                    validator: (val) => Validators.confirmPassword(
                      val,
                      _passwordController.text,
                    ),
                  ),
                  const SizedBox(height: 28),

                  AppButton(
                    text: 'Complete Registration',
                    icon: Icons.person_add_rounded,
                    isLoading: authProvider.isLoading,
                    onPressed: _handleRegister,
                  ),
                  const SizedBox(height: 20),

                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: AppColors.primaryTeal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
