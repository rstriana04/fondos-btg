import 'package:flutter_test/flutter_test.dart';
import 'package:fondos_btg/features/funds/domain/entities/fund.dart';

void main() {
  const tFundFpv = Fund(
    id: 1,
    name: 'FPV_BTG_PACTUAL_RECAUDADORA',
    minAmount: 75000,
    category: 'FPV',
  );

  const tFundFic = Fund(
    id: 3,
    name: 'DEUDAPRIVADA',
    minAmount: 50000,
    category: 'FIC',
  );

  test('isFpv should return true for FPV category', () {
    expect(tFundFpv.isFpv, true);
    expect(tFundFpv.isFic, false);
  });

  test('isFic should return true for FIC category', () {
    expect(tFundFic.isFic, true);
    expect(tFundFic.isFpv, false);
  });

  test('two funds with the same props should be equal', () {
    const fund1 = Fund(id: 1, name: 'TEST', minAmount: 100, category: 'FPV');
    const fund2 = Fund(id: 1, name: 'TEST', minAmount: 100, category: 'FPV');
    expect(fund1, equals(fund2));
  });

  test('two funds with different props should not be equal', () {
    const fund1 = Fund(id: 1, name: 'TEST', minAmount: 100, category: 'FPV');
    const fund2 = Fund(id: 2, name: 'TEST', minAmount: 100, category: 'FPV');
    expect(fund1, isNot(equals(fund2)));
  });
}
