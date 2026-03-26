import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fondos_btg/core/error/failures.dart';
import 'package:fondos_btg/features/funds/domain/entities/fund.dart';
import 'package:fondos_btg/features/funds/domain/repositories/fund_repository.dart';
import 'package:fondos_btg/features/funds/domain/usecases/subscribe_to_fund.dart';
import 'package:fondos_btg/features/portfolio/domain/entities/subscription.dart';
import 'package:fondos_btg/features/portfolio/domain/repositories/portfolio_repository.dart';

class MockFundRepository extends Mock implements FundRepository {}

class MockPortfolioRepository extends Mock implements PortfolioRepository {}

void main() {
  late SubscribeToFundUseCase useCase;
  late MockFundRepository mockFundRepo;
  late MockPortfolioRepository mockPortfolioRepo;

  setUp(() {
    mockFundRepo = MockFundRepository();
    mockPortfolioRepo = MockPortfolioRepository();
    useCase = SubscribeToFundUseCase(mockFundRepo, mockPortfolioRepo);
  });

  const tFund = Fund(
    id: 4,
    name: 'FDO-ACCIONES',
    minAmount: 250000,
    category: 'FIC',
  );

  test('should return InsufficientBalanceFailure when balance is less than minAmount', () async {
    final result = await useCase(
      fund: tFund,
      currentBalance: 100000,
      notificationMethod: 'EMAIL',
    );

    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure, isA<InsufficientBalanceFailure>()),
      (_) => fail('Should be Left'),
    );
    verifyZeroInteractions(mockFundRepo);
    verifyZeroInteractions(mockPortfolioRepo);
  });

  test('should return AlreadySubscribedFailure when user is already subscribed', () async {
    final existingSubscription = Subscription(
      id: 1,
      fundId: 4,
      fundName: 'FDO-ACCIONES',
      category: 'FIC',
      amount: 250000,
      subscribedAt: DateTime(2026, 3, 25),
    );

    when(() => mockPortfolioRepo.getActiveSubscriptions())
        .thenAnswer((_) async => Right([existingSubscription]));

    final result = await useCase(
      fund: tFund,
      currentBalance: 500000,
      notificationMethod: 'EMAIL',
    );

    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure, isA<AlreadySubscribedFailure>()),
      (_) => fail('Should be Left'),
    );
    verify(() => mockPortfolioRepo.getActiveSubscriptions()).called(1);
    verifyZeroInteractions(mockFundRepo);
  });

  test('should return updated balance on successful subscription', () async {
    when(() => mockPortfolioRepo.getActiveSubscriptions())
        .thenAnswer((_) async => const Right([]));
    when(() => mockFundRepo.subscribeToFund(
          fundId: any(named: 'fundId'),
          amount: any(named: 'amount'),
          notificationMethod: any(named: 'notificationMethod'),
        )).thenAnswer((_) async => const Right(250000));

    final result = await useCase(
      fund: tFund,
      currentBalance: 500000,
      notificationMethod: 'SMS',
    );

    expect(result, const Right(250000));
    verify(() => mockPortfolioRepo.getActiveSubscriptions()).called(1);
    verify(() => mockFundRepo.subscribeToFund(
          fundId: 4,
          amount: 250000,
          notificationMethod: 'SMS',
        )).called(1);
  });
}
