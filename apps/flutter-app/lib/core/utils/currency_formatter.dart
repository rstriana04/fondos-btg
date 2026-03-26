import 'package:intl/intl.dart';

abstract final class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'es_CO',
    symbol: '\$',
    decimalDigits: 0,
    customPattern: '\u00A4#,##0',
  );

  /// Formats a number as COP currency.
  /// Example: 500000 -> $500.000
  static String format(num amount) {
    return _formatter.format(amount).replaceAll(',', '.');
  }

  /// Formats with sign prefix.
  /// Example: 75000 -> +$75.000 or -$75.000
  static String formatWithSign(num amount, {bool positive = true}) {
    final formatted = format(amount.abs());
    return positive ? '+$formatted' : '-$formatted';
  }
}
