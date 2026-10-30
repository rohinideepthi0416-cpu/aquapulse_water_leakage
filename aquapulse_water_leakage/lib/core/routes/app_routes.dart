import 'package:flutter/material.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/admin_login_screen.dart';
import '../../screens/dashboard/user_dashboard_screen.dart';
import '../../screens/complaints/report_complaint_screen.dart';
import '../../screens/complaints/my_complaints_screen.dart';
import '../../screens/complaints/complaint_details_screen.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/admin/admin_dashboard_screen.dart';
import '../../screens/admin/admin_complaint_details_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String adminLogin = '/admin-login';
  static const String userDashboard = '/user-dashboard';
  static const String reportComplaint = '/report-complaint';
  static const String myComplaints = '/my-complaints';
  static const String complaintDetails = '/complaint-details';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String adminDashboard = '/admin-dashboard';
  static const String adminComplaintDetails = '/admin-complaint-details';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    adminLogin: (context) => const AdminLoginScreen(),
    userDashboard: (context) => const UserDashboardScreen(),
    reportComplaint: (context) => const ReportComplaintScreen(),
    myComplaints: (context) => const MyComplaintsScreen(),
    complaintDetails: (context) => const ComplaintDetailsScreen(),
    notifications: (context) => const NotificationsScreen(),
    profile: (context) => const ProfileScreen(),
    adminDashboard: (context) => const AdminDashboardScreen(),
    adminComplaintDetails: (context) => const AdminComplaintDetailsScreen(),
  };
}
