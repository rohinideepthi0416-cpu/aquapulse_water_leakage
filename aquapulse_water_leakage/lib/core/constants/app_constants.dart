/// Application-wide constants for AquaPulse
class AppConstants {
  AppConstants._();

  static const String appName = 'AquaPulse';
  static const String appTagline = 'Every Drop Counts.';
  static const String appVersion = '1.0.0';

  // Demo Credentials (documented for practical / evaluation use)
  static const String demoUserEmail = 'citizen@aquapulse.org';
  static const String demoUserPassword = 'Citizen@123';
  static const String demoUserName = 'Rohini Citizen';
  static const String demoUserPhone = '9876543210';
  static const String demoUserAddress = 'Block 4, Emerald Heights, Bengaluru';

  static const String demoAdminEmail = 'admin@aquapulse.org';
  static const String demoAdminPassword = 'Admin@123';
  static const String demoAdminName = 'Municipal Water Officer';
  static const String demoAdminPhone = '9845012345';
  static const String demoAdminAddress = 'City Water Board HQ, Zone A';

  // Roles
  static const String roleCitizen = 'citizen';
  static const String roleAdmin = 'admin';

  // Leakage Types
  static const List<String> leakageTypes = [
    'Pipeline Leak',
    'Overflowing Tank',
    'Broken Public Tap',
    'Drainage / Sewage Leak',
    'Water Meter Damage',
    'Other Water Waste',
  ];

  // Severity Levels
  static const List<String> severityLevels = [
    'Low',
    'Medium',
    'High',
    'Critical',
  ];

  // Statuses
  static const String statusPending = 'Pending';
  static const String statusReviewed = 'Reviewed';
  static const String statusInProgress = 'In Progress';
  static const String statusResolved = 'Resolved';

  static const List<String> statusWorkflow = [
    statusPending,
    statusReviewed,
    statusInProgress,
    statusResolved,
  ];

  // API Endpoint: Open-Meteo public open water & weather data API (no key required)
  static const String weatherApiUrl =
      'https://api.open-meteo.com/v1/forecast?latitude=12.9716&longitude=77.5946&current=temperature_2m,relative_humidity_2m,precipitation,rain&daily=precipitation_sum&timezone=auto';
}
