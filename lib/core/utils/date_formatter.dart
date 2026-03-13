import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  /// Formats DateTime to API format (YYYYMMDD)
  static String toApiFormat(DateTime date) {
    return DateFormat('yyyyMMdd').format(date);
  }

  /// Parses API format (YYYYMMDD) to DateTime
  static DateTime? fromApiFormat(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateFormat('yyyyMMdd').parse(dateString);
    } catch (_) {
      return null;
    }
  }

  /// Formats DateTime for display (e.g., "25 Oct 2025")
  static String toDisplayFormat(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  /// Formats DateTime for display with day (e.g., "Sat, 25 Oct 2025")
  static String toDisplayFormatWithDay(DateTime date) {
    return DateFormat('E, d MMM yyyy').format(date);
  }

  /// Formats time string from API (HH:mm:ss) to display format (HH:mm)
  static String formatTime(String? time) {
    if (time == null || time.isEmpty) return '';
    try {
      final parts = time.split(':');
      if (parts.length >= 2) {
        return '${parts[0]}:${parts[1]}';
      }
      return time;
    } catch (_) {
      return time;
    }
  }

  /// Formats booking date from API (YYYY-MM-DD) to display format
  static String formatBookingDate(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsed = DateTime.parse(date);
      return toDisplayFormat(parsed);
    } catch (_) {
      return date;
    }
  }

  /// Get relative date description
  static String getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    final difference = dateOnly.difference(today).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference > 1 && difference <= 7) {
      return DateFormat('EEEE').format(date); // Day name
    } else {
      return toDisplayFormat(date);
    }
  }
}