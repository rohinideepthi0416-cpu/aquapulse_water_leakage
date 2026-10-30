import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../services/session_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final AnimationController _rippleController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
    );

    _scaleController.forward();
    _navTimer = Timer(const Duration(milliseconds: 2400), () {
      if (mounted) _checkNextScreen();
    });
  }

  Future<void> _checkNextScreen() async {
    final authProvider = context.read<AuthProvider>();
    final hasSession = await authProvider.checkExistingSession();

    if (!mounted) return;

    if (hasSession) {
      if (authProvider.isAdmin) {
        Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.userDashboard);
      }
      return;
    }

    final sessionService = SessionService();
    final onboardingDone = await sessionService.isOnboardingCompleted();

    if (!mounted) return;

    if (onboardingDone) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _scaleController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryTeal,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Water Ripple Effect
          AnimatedBuilder(
            animation: _rippleController,
            builder: (context, child) {
              return CustomPaint(
                painter: _RipplePainter(
                  progress: _rippleController.value,
                  color: AppColors.turquoise.withValues(alpha: 0.25),
                ),
                size: const Size(double.infinity, double.infinity),
              );
            },
          ),

          // Central Logo and Branding
          ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Water Drop Logo Container
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.water_drop_rounded,
                          size: 64,
                          color: AppColors.turquoise,
                        ),
                        Positioned(
                          bottom: 24,
                          child: Icon(
                            Icons.bolt_rounded,
                            size: 24,
                            color: AppColors.coralOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // App Name
                const Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                // Tagline with Fade
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      AppConstants.appTagline,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Loading Indicator
          Positioned(
            bottom: 48,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final double progress;
  final Color color;

  _RipplePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) * 0.48;

    for (int i = 0; i < 3; i++) {
      final currentProgress = (progress + (i * 0.33)) % 1.0;
      final radius = maxRadius * currentProgress;
      final opacity = (1.0 - currentProgress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = color.withValues(alpha: opacity * 0.28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
