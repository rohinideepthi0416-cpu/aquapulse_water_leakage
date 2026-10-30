import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/responsive_layout.dart';
import 'home_tab.dart';
import '../complaints/my_complaints_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;
      if (user?.id != null) {
        context.read<NotificationProvider>().loadNotifications(user!.id!);
      }
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = context.watch<NotificationProvider>().unreadCount;

    final tabs = [
      HomeTab(onNavigateTab: _onTabSelected),
      const MyComplaintsScreen(isTab: true),
      const NotificationsScreen(isTab: true),
      const ProfileScreen(isTab: true),
    ];

    return Scaffold(
      backgroundColor: AppColors.paleAqua,
      appBar: AppBar(
        titleSpacing: 16,
        elevation: 0,
        backgroundColor: AppColors.primaryTeal,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.water_drop_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _getAppBarTitle(_currentIndex),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: unreadCount > 0,
              label: Text('$unreadCount'),
              backgroundColor: AppColors.coralOrange,
              child: const Icon(Icons.notifications_outlined, size: 24),
            ),
            tooltip: 'Notifications',
            onPressed: () => _onTabSelected(2),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ResponsiveContentWrapper(
          maxWidth: 900,
          child: tabs[_currentIndex],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabSelected,
        backgroundColor: Colors.white,
        elevation: 4,
        indicatorColor: AppColors.primaryTealLight,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(
              Icons.home_rounded,
              color: AppColors.primaryTeal,
            ),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(
              Icons.assignment_rounded,
              color: AppColors.primaryTeal,
            ),
            label: 'My Complaints',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: unreadCount > 0,
              label: Text('$unreadCount'),
              backgroundColor: AppColors.coralOrange,
              child: const Icon(Icons.notifications_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: unreadCount > 0,
              label: Text('$unreadCount'),
              backgroundColor: AppColors.coralOrange,
              child: const Icon(
                Icons.notifications_rounded,
                color: AppColors.primaryTeal,
              ),
            ),
            label: 'Notifications',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(
              Icons.person_rounded,
              color: AppColors.primaryTeal,
            ),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0 || _currentIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.reportComplaint);
              },
              backgroundColor: AppColors.coralOrange,
              foregroundColor: Colors.white,
              elevation: 4,
              icon: const Icon(Icons.add_location_alt_rounded, size: 20),
              label: const Text(
                'Report Leak',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            )
          : null,
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'AquaPulse Dashboard';
      case 1:
        return 'My Complaints';
      case 2:
        return 'In-App Alerts';
      case 3:
        return 'Citizen Profile';
      default:
        return 'AquaPulse';
    }
  }
}
