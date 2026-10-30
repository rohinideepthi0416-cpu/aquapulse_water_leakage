import 'package:flutter/material.dart';

/// AquaPulse Application Color Palette
/// Matches the required design specification:
/// - Deep teal: Main brand
/// - Turquoise & aqua: Interactive elements
/// - Coral orange: Urgent complaints & highlights
/// - Violet: Selected secondary features
/// - Mint green: Resolved / success
/// - Amber: Pending status
/// - Red: Critical severity
/// - Pale aqua: Background
/// - Charcoal / Navy: Readable text
class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primaryTeal = Color(0xFF006D77);
  static const Color primaryTealDark = Color(0xFF00494F);
  static const Color primaryTealLight = Color(0xFFE2F3F5);

  // Interactive Accents
  static const Color turquoise = Color(0xFF05BFDB);
  static const Color aqua = Color(0xFF83C5BE);
  static const Color paleAqua = Color(0xFFF4FBFB);
  static const Color softSurface = Color(0xFFEBF6F6);

  // Highlighting & Status Accents
  static const Color coralOrange = Color(0xFFFF6B6B);
  static const Color violetAccent = Color(0xFF6C5CE7);
  static const Color violetLight = Color(0xFFEBE8FC);
  static const Color mintGreen = Color(0xFF2EC4B6);
  static const Color mintGreenLight = Color(0xFFE0F7F5);
  static const Color amberPending = Color(0xFFFFB703);
  static const Color amberLight = Color(0xFFFFF4D6);
  static const Color redCritical = Color(0xFFD90429);
  static const Color redLight = Color(0xFFFFE5E8);

  // Neutral & Typography
  static const Color textDark = Color(0xFF0B192C);
  static const Color textMuted = Color(0xFF596E79);
  static const Color textLight = Color(0xFF8D99AE);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFD8E2DC);
  static const Color divider = Color(0xFFE8ECEF);

  // Severity Colors
  static Color severityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return redCritical;
      case 'high':
        return coralOrange;
      case 'medium':
        return amberPending;
      case 'low':
      default:
        return turquoise;
    }
  }

  // Status Colors
  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'resolved':
        return mintGreen;
      case 'in progress':
      case 'in_progress':
        return violetAccent;
      case 'reviewed':
        return turquoise;
      case 'pending':
      default:
        return amberPending;
    }
  }
}
