import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fondos_btg/core/error/failures.dart';
import 'package:fondos_btg/features/funds/domain/entities/fund.dart';
import 'package:fondos_btg/features/funds/domain/usecases/get_funds.dart';
import 'package:fondos_btg/features/funds/domain/usecases/subscribe_to_fund.dart';
import 'package:fondos_btg/features/funds/presentation/bloc/fund_bloc.dart';
import 'package:fondos_btg/features/funds/presentation/bloc/fund_event.dart';
import 'package:fondos_btg/features/funds/presentation/bloc/fund_state.dart';

class MockGetFundsUseCase extends Mock implements GetFundsUseCase {}

class MockSubscribeToFundUseCase extends Mock implements SubscribeToFundUseCase {}

void main() {
  late FundBloc bloc;
  late MockGetFundsUseCase mockGetFunds;
  late MockSubscribeToFundUseCase mockSubscribeToFund;

  setUpAll(() {
    registerFallbackValue(
      const Fund(id: 0, name: '', minAmount: 0, category: 'FPV'),
    );
  });

  setUp(() {
    mockGetFunds = MockGetFundsUseCase();
    mockSubscribeToFund = MockSubscribeToFundUseCase();
    bloc = FundBloc(
      getFunds: mockGetFunds,
      subscribeToFund: mockSubscribeToFund,
    );
  });

  tearDown(() => bloc.close());

  const tFunds = [
    Fund(id: 1, name: 'FPV_BTG_PACTUAL_RECAUDADORA', minAmount: 75000, category: 'FPV'),
    Fund(id: 3, name: 'DEUDAPRIVADA', minAmount: 50000, category: 'FIC'),
  ];

  test('initial state should be FundState with initial status', () {
    expect(bloc.state, const FundState());
    expect(bloc.state.status, FundStatus.initial);
  });

  blocTest<FundBloc, FundState>(
    'emits [loading, loaded] when LoadFunds succeeds',
    build: () {
      when(() => mockGetFunds()).thenAnswer((_) async => const Right(tFunds));
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadFunds()),
    expect: () => [
      const FundState(status: FundStatus.loading),
      const FundState(status: FundStatus.loaded, funds: tFunds),
    ],
    verify: (_) {
      verify(() => mockGetFunds()).called(1);
    },
  );

  blocTest<FundBloc, FundState>(
    'emits [loading, error] when LoadFunds fails',
    build: () {
      when(() => mockGetFunds())
          .thenAnswer((_) async => const Left(ServerFailure()));
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadFunds()),
    expect: () => [
      const FundState(status: FundStatus.loading),
      const FundState(
        status: FundStatus.error,
        errorMessage: 'Ha ocurrido un error en el servidor',
      ),
    ],
  );

  blocTest<FundBloc, FundState>(
    'emits [subscriptionLoading, subscriptionSuccess] when SubscribeToFund succeeds',
    build: () {
      when(() => mockSubscribeToFund(
            fund: any(named: 'fund'),
            amount: any(named: 'amount'),
            currentBalance: any(named: 'currentBalance'),
            notificationMethod: any(named: 'notificationMethod'),
          )).thenAnswer((_) async => const Right(425000));
      return bloc;
    },
    act: (bloc) => bloc.add(const SubscribeToFund(
      fund: Fund(id: 1, name: 'FPV_BTG_PACTUAL_RECAUDADORA', minAmount: 75000, category: 'FPV'),
      amount: 75000,
      currentBalance: 500000,
      notificationMethod: 'EMAIL',
    )),
    expect: () => [
      const FundState(subscriptionStatus: SubscriptionStatus.loading),
      const FundState(
        subscriptionStatus: SubscriptionStatus.success,
        newBalance: 425000,
      ),
    ],
  );

  blocTest<FundBloc, FundState>(
    'emits [subscriptionLoading, subscriptionError] when SubscribeToFund fails with insufficient balance',
    build: () {
      when(() => mockSubscribeToFund(
            fund: any(named: 'fund'),
            amount: any(named: 'amount'),
            currentBalance: any(named: 'currentBalance'),
            notificationMethod: any(named: 'notificationMethod'),
          )).thenAnswer((_) async => const Left(InsufficientBalanceFailure()));
      return bloc;
    },
    act: (bloc) => bloc.add(const SubscribeToFund(
      fund: Fund(id: 4, name: 'FDO-ACCIONES', minAmount: 250000, category: 'FIC'),
      amount: 250000,
      currentBalance: 100000,
      notificationMethod: 'SMS',
    )),
    expect: () => [
      const FundState(subscriptionStatus: SubscriptionStatus.loading),
      const FundState(
        subscriptionStatus: SubscriptionStatus.error,
        subscriptionError: 'No tiene saldo disponible para vincularse al fondo',
      ),
    ],
  );
}
