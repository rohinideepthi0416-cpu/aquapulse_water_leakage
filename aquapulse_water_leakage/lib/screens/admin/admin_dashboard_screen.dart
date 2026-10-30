import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/complaint_provider.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/complaint_card.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/responsive_layout.dart';
import 'admin_complaint_details_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ComplaintProvider>().loadAdminComplaints();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exit Admin Portal'),
        content: const Text(
          'Do you wish to log out of the administrative console?',
        ),
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

    if (confirmed == true && mounted) {
      await context.read<AuthProvider>().logout();
      if (mounted) {
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
    final complaintProv = context.watch<ComplaintProvider>();
    final adminUser = context.watch<AuthProvider>().currentUser;
    final complaints = complaintProv.adminComplaints;

    return Scaffold(
      backgroundColor: AppColors.paleAqua,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.admin_panel_settings_rounded, size: 24),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'AquaPulse Admin Portal',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.violetAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Complaints',
            onPressed: () => complaintProv.loadAdminComplaints(),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign Out',
            onPressed: _handleLogout,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => complaintProv.loadAdminComplaints(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: ResponsiveContentWrapper(
            maxWidth: 1000,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Admin Greeting Banner
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.violetAccent, Color(0xFF4A3E9E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.violetAccent.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.white24,
                        child: Icon(
                          Icons.shield_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              adminUser?.name ?? 'Water Board Officer',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Municipal Water Supply Operations & Dispatch',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Statistics Section (6 Metrics as requested)
                const Text(
                  'Department Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                _buildAdminStats(complaintProv),
                const SizedBox(height: 24),

                // Search & Filter Controls
                _buildSearchAndFilters(complaintProv),
                const SizedBox(height: 18),

                // Complaints List Header
                LayoutBuilder(
                  builder: (context, constraints) {
                    final title = Text(
                      'All Citizen Complaints (${complaints.length})',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    );
                    final filterSummary = Text(
                      'Showing ${complaintProv.adminStatusFilter} • ${complaintProv.adminSeverityFilter}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    );

                    if (constraints.maxWidth < 520) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          title,
                          const SizedBox(height: 4),
                          filterSummary,
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(child: title),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: filterSummary,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),

                if (complaintProv.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (complaints.isEmpty)
                  EmptyStateView(
                    title: 'No Matching Complaints',
                    message:
                        'No complaints match the current filter or search criteria.',
                    icon: Icons.search_off_rounded,
                    buttonText: 'Reset Filters',
                    onButtonPressed: () {
                      _searchController.clear();
                      complaintProv.setAdminFilters(
                        status: 'All',
                        severity: 'All',
                        query: '',
                        sortBy: 'newest',
                      );
                    },
                  )
                else
                  ...complaints.map(
                    (c) => ComplaintCard(
                      complaint: c,
                      showUserInfo:
                          true, // Shows complainant name & phone for admin!
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AdminComplaintDetailsScreen(complaint: c),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminStats(ComplaintProvider prov) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 550 ? 3 : 2;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.35,
          children: [
            StatCard(
              title: 'Total',
              count: prov.adminTotalCount,
              icon: Icons.folder_open_rounded,
              accentColor: AppColors.primaryTeal,
              onTap: () => prov.setAdminFilters(status: 'All'),
            ),
            StatCard(
              title: 'Pending',
              count: prov.adminPendingCount,
              icon: Icons.hourglass_top_rounded,
              accentColor: AppColors.amberPending,
              onTap: () => prov.setAdminFilters(status: 'Pending'),
            ),
            StatCard(
              title: 'In Progress',
              count: prov.adminInProgressCount,
              icon: Icons.build_rounded,
              accentColor: AppColors.violetAccent,
              onTap: () => prov.setAdminFilters(status: 'In Progress'),
            ),
            StatCard(
              title: 'Resolved',
              count: prov.adminResolvedCount,
              icon: Icons.check_circle_rounded,
              accentColor: AppColors.mintGreen,
              onTap: () => prov.setAdminFilters(status: 'Resolved'),
            ),
            StatCard(
              title: 'High Priority',
              count: prov.adminHighPriorityCount,
              icon: Icons.priority_high_rounded,
              accentColor: AppColors.coralOrange,
              onTap: () => prov.setAdminFilters(severity: 'High'),
            ),
            StatCard(
              title: 'Critical',
              count: prov.adminCriticalCount,
              icon: Icons.warning_rounded,
              accentColor: AppColors.redCritical,
              onTap: () => prov.setAdminFilters(severity: 'Critical'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchAndFilters(ComplaintProvider prov) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search ID, title, area, or citizen...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        prov.setAdminFilters(query: '');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (val) {
              prov.setAdminFilters(query: val);
            },
          ),
          const SizedBox(height: 10),

          // Horizontal Scrolling Filter Dropdowns
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDropdown(
                  label: 'Status',
                  value: prov.adminStatusFilter,
                  items: ['All', ...AppConstants.statusWorkflow],
                  onChanged: (val) => prov.setAdminFilters(status: val),
                ),
                const SizedBox(width: 8),
                _buildDropdown(
                  label: 'Severity',
                  value: prov.adminSeverityFilter,
                  items: ['All', ...AppConstants.severityLevels],
                  onChanged: (val) => prov.setAdminFilters(severity: val),
                ),
                const SizedBox(width: 8),
                _buildDropdown(
                  label: 'Sort',
                  value: prov.adminSortBy,
                  items: ['newest', 'oldest', 'priority'],
                  onChanged: (val) => prov.setAdminFilters(sortBy: val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.paleAqua,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
          DropdownButton<String>(
            value: value,
            underline: const SizedBox(),
            isDense: true,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
            items: items.map((item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ],
      ),
    );
  }
}
