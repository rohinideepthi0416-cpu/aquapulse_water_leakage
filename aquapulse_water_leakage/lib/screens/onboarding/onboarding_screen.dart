import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../services/session_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/responsive_layout.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingItem> _pages = const [
    _OnboardingItem(
      title: 'Report Water Leaks',
      description:
          'Spot a burst pipe, broken public tap, or overflowing tank? Report issues instantly with exact landmarks and severity.',
      icon: Icons.water_drop_rounded,
      accentColor: AppColors.primaryTeal,
    ),
    _OnboardingItem(
      title: 'Track Complaints Live',
      description:
          'Receive automatic in-app alerts as technicians review, dispatch repair crews, and mark your complaint resolved.',
      icon: Icons.track_changes_rounded,
      accentColor: AppColors.violetAccent,
    ),
    _OnboardingItem(
      title: 'Save Every Single Drop',
      description:
          'Together we prevent millions of litres of precious municipal drinking water from being lost every day. Every drop counts!',
      icon: Icons.eco_rounded,
      accentColor: AppColors.mintGreen,
    ),
  ];

  Future<void> _completeOnboarding() async {
    final sessionService = SessionService();
    await sessionService.setOnboardingCompleted();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paleAqua,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _completeOnboarding,
            child: const Text(
              'Skip',
              style: TextStyle(
                color: AppColors.primaryTeal,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final pageHeight = constraints.maxHeight * 0.68;
            final compact = constraints.maxHeight < 620;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: ResponsiveContentWrapper(
                  maxWidth: 600,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(
                        height: pageHeight,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _pages.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final item = _pages[index];
                            return SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: pageHeight,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 140,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        color: item.accentColor.withValues(
                                          alpha: 0.15,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        item.icon,
                                        size: 72,
                                        color: item.accentColor,
                                      ),
                                    ),
                                    const SizedBox(height: 36),
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      item.description,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: AppColors.textMuted,
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_pages.length, (index) {
                          final isSelected = index == _currentPage;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: isSelected ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryTeal
                                  : AppColors.borderLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: compact ? 16 : 32),
                      AppButton(
                        text: _currentPage == _pages.length - 1
                            ? 'Get Started'
                            : 'Continue',
                        icon: _currentPage == _pages.length - 1
                            ? Icons.check_rounded
                            : Icons.arrow_forward_rounded,
                        onPressed: () {
                          if (_currentPage == _pages.length - 1) {
                            _completeOnboarding();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                      SizedBox(height: compact ? 16 : 32),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OnboardingItem {
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;

  const _OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
  });
}
