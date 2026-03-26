import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fondos_btg/core/error/failures.dart';
import 'package:fondos_btg/features/funds/domain/entities/fund.dart';
import 'package:fondos_btg/features/funds/domain/repositories/fund_repository.dart';
import 'package:fondos_btg/features/funds/domain/usecases/get_funds.dart';

class MockFundRepository extends Mock implements FundRepository {}

void main() {
  late GetFundsUseCase useCase;
  late MockFundRepository mockRepository;

  setUp(() {
    mockRepository = MockFundRepository();
    useCase = GetFundsUseCase(mockRepository);
  });

  const tFunds = [
    Fund(id: 1, name: 'FPV_BTG_PACTUAL_RECAUDADORA', minAmount: 75000, category: 'FPV'),
    Fund(id: 2, name: 'FPV_BTG_PACTUAL_ECOPETROL', minAmount: 125000, category: 'FPV'),
    Fund(id: 3, name: 'DEUDAPRIVADA', minAmount: 50000, category: 'FIC'),
  ];

  test('should return list of funds from the repository', () async {
    when(() => mockRepository.getFunds())
        .thenAnswer((_) async => const Right(tFunds));

    final result = await useCase();

    expect(result, const Right(tFunds));
    verify(() => mockRepository.getFunds()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when repository fails', () async {
    when(() => mockRepository.getFunds())
        .thenAnswer((_) async => const Left(ServerFailure()));

    final result = await useCase();

    expect(result, const Left(ServerFailure()));
    verify(() => mockRepository.getFunds()).called(1);
  });
}
