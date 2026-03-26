import 'package:intl/intl.dart';

abstract final class DateFormatter {
  /// Formats a DateTime to a human-readable string.
  /// Example: "25 mar 2026, 10:15 a.m."
  static String format(DateTime date) {
    final day = date.day;
    final month = _monthAbbreviation(date.month);
    final year = date.year;
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour < 12 ? 'a.m.' : 'p.m.';
    final displayHour = hour == 0
        ? 12
        : hour > 12
            ? hour - 12
            : hour;

    return '$day $month $year, $displayHour:$minute $period';
  }

  /// Formats a DateTime to a short date string.
  /// Example: "25 mar 2026"
  static String formatShort(DateTime date) {
    final day = date.day;
    final month = _monthAbbreviation(date.month);
    final year = date.year;
    return '$day $month $year';
  }

  /// Parses an ISO 8601 date string to DateTime.
  static DateTime parse(String dateString) {
    return DateTime.parse(dateString);
  }

  static String _monthAbbreviation(int month) {
    const months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
    ];
    return months[month - 1];
  }
}
