import 'package:flutter_test/flutter_test.dart';
import 'package:fondos_btg/core/utils/currency_formatter.dart';

void main() {
  test('should format 500000 as \$500.000', () {
    expect(CurrencyFormatter.format(500000), '\$500.000');
  });

  test('should format 75000 as \$75.000', () {
    expect(CurrencyFormatter.format(75000), '\$75.000');
  });

  test('should format 0 as \$0', () {
    expect(CurrencyFormatter.format(0), '\$0');
  });

  test('should format 1000000 as \$1.000.000', () {
    expect(CurrencyFormatter.format(1000000), '\$1.000.000');
  });
}
