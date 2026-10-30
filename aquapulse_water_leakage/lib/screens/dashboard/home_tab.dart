import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/complaint_provider.dart';
import '../../providers/environmental_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/complaint_card.dart';
import '../../widgets/responsive_layout.dart';

class HomeTab extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const HomeTab({super.key, this.onNavigateTab});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;
      if (user?.id != null) {
        context.read<ComplaintProvider>().loadUserComplaints(user!.id!);
      }
      context.read<EnvironmentalProvider>().fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final complaintProv = context.watch<ComplaintProvider>();
    final envProv = context.watch<EnvironmentalProvider>();

    return RefreshIndicator(
      onRefresh: () async {
        if (user?.id != null) {
          await complaintProv.loadUserComplaints(user!.id!);
        }
        await envProv.fetchData(force: true);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: ResponsiveContentWrapper(
          maxWidth: 760,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner
              _buildWelcomeCard(user?.name ?? 'Citizen'),
              const SizedBox(height: 20),

              // Statistics Section
              const Text(
                'My Complaint Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              _buildStatsGrid(complaintProv),
              const SizedBox(height: 24),

              // Report a Leak Hero Banner
              _buildReportHeroBanner(context),
              const SizedBox(height: 24),

              // Environmental API Information Card
              _buildEnvironmentalApiCard(envProv),
              const SizedBox(height: 24),

              // Recent Complaints Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Complaints',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  if (complaintProv.userComplaints.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        widget.onNavigateTab?.call(1); // My Complaints Tab
                      },
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          color: AppColors.primaryTeal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              if (complaintProv.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (complaintProv.userComplaints.isEmpty)
                _buildEmptyRecentComplaints(context)
              else
                ...complaintProv.userComplaints
                    .take(3)
                    .map(
                      (c) => ComplaintCard(
                        complaint: c,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.complaintDetails,
                            arguments: c,
                          );
                        },
                      ),
                    ),

              const SizedBox(height: 24),
              // Water Conservation Tips Card
              _buildConservationTipsCard(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(String userName) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryTeal, Color(0xFF008B94)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryTeal.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $userName 👋',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Thank you for actively protecting our local water supply. Every reported leak makes a difference!',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.water_drop_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(ComplaintProvider prov) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: [
            StatCard(
              title: 'Total Reports',
              count: prov.userTotalCount,
              icon: Icons.assignment_outlined,
              accentColor: AppColors.primaryTeal,
              onTap: () => widget.onNavigateTab?.call(1),
            ),
            StatCard(
              title: 'Pending',
              count: prov.userPendingCount,
              icon: Icons.hourglass_top_rounded,
              accentColor: AppColors.amberPending,
              onTap: () => widget.onNavigateTab?.call(1),
            ),
            StatCard(
              title: 'In Progress',
              count: prov.userInProgressCount,
              icon: Icons.build_circle_outlined,
              accentColor: AppColors.violetAccent,
              onTap: () => widget.onNavigateTab?.call(1),
            ),
            StatCard(
              title: 'Resolved',
              count: prov.userResolvedCount,
              icon: Icons.check_circle_outline,
              accentColor: AppColors.mintGreen,
              onTap: () => widget.onNavigateTab?.call(1),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReportHeroBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.coralOrange,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.coralOrange.withValues(alpha: 0.28),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Found a Water Leak?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Submit the location and severity to dispatch field technicians.',
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.reportComplaint);
                  },
                  icon: const Icon(Icons.add_location_alt_rounded, size: 18),
                  label: const Text('Report Leakage Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.coralOrange,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.plumbing_rounded, size: 64, color: Colors.white24),
        ],
      ),
    );
  }

  Widget _buildEnvironmentalApiCard(EnvironmentalProvider envProv) {
    final data = envProv.data;
    final isLoading = envProv.isLoading;

    return AppCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(18),
      border: Border.all(
        color: AppColors.turquoise.withValues(alpha: 0.35),
        width: 1.2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.turquoise.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.cloud_sync_rounded,
                      color: AppColors.turquoise,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Live Environmental Data',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        'Open-Meteo REST API Integration',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: isLoading
                    ? null
                    : () => envProv.fetchData(force: true),
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(
                        Icons.refresh_rounded,
                        color: AppColors.primaryTeal,
                        size: 22,
                      ),
                tooltip: 'Refresh Environmental Data',
              ),
            ],
          ),
          const Divider(height: 24, color: AppColors.divider),
          if (data != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildEnvMetric(
                  icon: Icons.thermostat_rounded,
                  label: 'Temperature',
                  value: '${data.temperature.toStringAsFixed(1)}°C',
                  color: AppColors.coralOrange,
                ),
                _buildEnvMetric(
                  icon: Icons.water_drop_rounded,
                  label: 'Humidity',
                  value: '${data.humidity.toStringAsFixed(0)}%',
                  color: AppColors.turquoise,
                ),
                _buildEnvMetric(
                  icon: Icons.grain_rounded,
                  label: 'Precipitation',
                  value: '${data.precipitation.toStringAsFixed(1)} mm',
                  color: AppColors.violetAccent,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryTealLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: AppColors.primaryTealDark,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      data.waterTip,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryTealDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Tap refresh to retrieve live atmospheric conditions.',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEnvMetric({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyRecentComplaints(BuildContext context) {
    return AppCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.mintGreen,
              size: 40,
            ),
            const SizedBox(height: 10),
            const Text(
              'No active complaints reported yet',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Report a pipeline leak or overflowing tank when you observe water waste.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConservationTipsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: AppColors.amberPending,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Water Conservation Insight',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '• Reporting leaks within 2 hours saves an average of 3,200 litres of treated water.\n'
            '• A leaking public tap wastes approximately 1 drop per second = 3,000 gallons/year.\n'
            '• Report overflowing community tanks to assist automated telemetry sensors.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
