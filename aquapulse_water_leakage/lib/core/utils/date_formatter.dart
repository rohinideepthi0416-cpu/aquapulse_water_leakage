import 'package:intl/intl.dart';

/// Date Formatter utility using intl package
class DateFormatter {
  DateFormatter._();

  static final DateFormat _dateTimeFormat = DateFormat(
    'MMM dd, yyyy • hh:mm a',
  );
  static final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  static final DateFormat _timeFormat = DateFormat('hh:mm a');

  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  static String formatDate(DateTime dateTime) {
    return _dateFormat.format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return _timeFormat.format(dateTime);
  }

  static String formatIso(String isoString) {
    try {
      final dt = DateTime.parse(isoString);
      return formatDateTime(dt);
    } catch (_) {
      return isoString;
    }
  }

  static String timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return formatDate(dateTime);
  }
}
