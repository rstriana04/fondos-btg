import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fondos_btg/core/error/failures.dart';
import 'package:fondos_btg/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:fondos_btg/features/portfolio/domain/usecases/cancel_subscription.dart';

class MockPortfolioRepository extends Mock implements PortfolioRepository {}

void main() {
  late CancelSubscriptionUseCase useCase;
  late MockPortfolioRepository mockRepository;

  setUp(() {
    mockRepository = MockPortfolioRepository();
    useCase = CancelSubscriptionUseCase(mockRepository);
  });

  test('should return restored balance on successful cancellation', () async {
    when(() => mockRepository.cancelSubscription(subscriptionId: any(named: 'subscriptionId')))
        .thenAnswer((_) async => const Right(575000));

    final result = await useCase(subscriptionId: 1);

    expect(result, const Right(575000));
    verify(() => mockRepository.cancelSubscription(subscriptionId: 1)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when cancellation fails', () async {
    when(() => mockRepository.cancelSubscription(subscriptionId: any(named: 'subscriptionId')))
        .thenAnswer((_) async => const Left(ServerFailure()));

    final result = await useCase(subscriptionId: 1);

    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure, isA<ServerFailure>()),
      (_) => fail('Should be Left'),
    );
  });

  test('should return NotFoundFailure when subscription does not exist', () async {
    when(() => mockRepository.cancelSubscription(subscriptionId: any(named: 'subscriptionId')))
        .thenAnswer((_) async => const Left(NotFoundFailure()));

    final result = await useCase(subscriptionId: 999);

    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure, isA<NotFoundFailure>()),
      (_) => fail('Should be Left'),
    );
  });
}
