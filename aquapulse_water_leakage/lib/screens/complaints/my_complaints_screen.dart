import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/complaint_provider.dart';
import '../../widgets/complaint_card.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/responsive_layout.dart';

class MyComplaintsScreen extends StatefulWidget {
  final bool isTab;

  const MyComplaintsScreen({super.key, this.isTab = false});

  @override
  State<MyComplaintsScreen> createState() => _MyComplaintsScreenState();
}

class _MyComplaintsScreenState extends State<MyComplaintsScreen> {
  final List<String> _filters = ['All', 'Pending', 'In Progress', 'Resolved'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;
      if (user?.id != null) {
        context.read<ComplaintProvider>().loadUserComplaints(user!.id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final complaintProv = context.watch<ComplaintProvider>();
    final user = context.watch<AuthProvider>().currentUser;
    final complaints = complaintProv.filteredUserComplaints;

    Widget body = Column(
      children: [
        // Filter Chips Row
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                final isSelected = complaintProv.activeUserFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (_) {
                      complaintProv.setUserFilter(filter);
                    },
                    backgroundColor: AppColors.paleAqua,
                    selectedColor: AppColors.primaryTeal,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textDark,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // List View of Complaints
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              if (user?.id != null) {
                await complaintProv.loadUserComplaints(user!.id!);
              }
            },
            child: complaintProv.isLoading
                ? const Center(child: CircularProgressIndicator())
                : complaints.isEmpty
                ? EmptyStateView(
                    title:
                        'No complaints in "${complaintProv.activeUserFilter}"',
                    message:
                        'You do not have any water leakage complaints matching this status filter.',
                    icon: Icons.assignment_late_outlined,
                    buttonText: 'Report New Leak',
                    onButtonPressed: () {
                      Navigator.pushNamed(context, AppRoutes.reportComplaint);
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: complaints.length,
                    itemBuilder: (context, index) {
                      final c = complaints[index];
                      return ResponsiveContentWrapper(
                        maxWidth: 760,
                        child: ComplaintCard(
                          complaint: c,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.complaintDetails,
                              arguments: c,
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );

    if (widget.isTab) {
      return body;
    }

    return Scaffold(
      backgroundColor: AppColors.paleAqua,
      appBar: AppBar(
        title: const Text('My Reported Complaints'),
        backgroundColor: AppColors.primaryTeal,
      ),
      body: body,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.reportComplaint);
        },
        backgroundColor: AppColors.coralOrange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_location_alt_rounded),
        label: const Text('Report Leak'),
      ),
    );
  }
}
