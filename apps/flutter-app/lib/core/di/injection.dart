import 'package:get_it/get_it.dart';
import 'package:fondos_btg/core/network/api_client.dart';

// Balance
import 'package:fondos_btg/features/balance/data/datasources/balance_remote_datasource.dart';
import 'package:fondos_btg/features/balance/data/repositories/balance_repository_impl.dart';
import 'package:fondos_btg/features/balance/domain/repositories/balance_repository.dart';
import 'package:fondos_btg/features/balance/domain/usecases/get_balance.dart';
import 'package:fondos_btg/features/balance/presentation/bloc/balance_bloc.dart';

// Funds
import 'package:fondos_btg/features/funds/data/datasources/fund_remote_datasource.dart';
import 'package:fondos_btg/features/funds/data/repositories/fund_repository_impl.dart';
import 'package:fondos_btg/features/funds/domain/repositories/fund_repository.dart';
import 'package:fondos_btg/features/funds/domain/usecases/get_funds.dart';
import 'package:fondos_btg/features/funds/domain/usecases/subscribe_to_fund.dart';
import 'package:fondos_btg/features/funds/presentation/bloc/fund_bloc.dart';

// Portfolio
import 'package:fondos_btg/features/portfolio/data/datasources/portfolio_remote_datasource.dart';
import 'package:fondos_btg/features/portfolio/data/repositories/portfolio_repository_impl.dart';
import 'package:fondos_btg/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:fondos_btg/features/portfolio/domain/usecases/cancel_subscription.dart';
import 'package:fondos_btg/features/portfolio/domain/usecases/get_active_subscriptions.dart';
import 'package:fondos_btg/features/portfolio/presentation/bloc/portfolio_bloc.dart';

// Transactions
import 'package:fondos_btg/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:fondos_btg/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:fondos_btg/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:fondos_btg/features/transactions/domain/usecases/get_transactions.dart';
import 'package:fondos_btg/features/transactions/presentation/bloc/transaction_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ==================== Core ====================
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // ==================== Balance ====================
  // Datasources
  sl.registerLazySingleton<BalanceRemoteDatasource>(
    () => BalanceRemoteDatasourceImpl(sl<ApiClient>()),
  );

  // Repositories
  sl.registerLazySingleton<BalanceRepository>(
    () => BalanceRepositoryImpl(sl<BalanceRemoteDatasource>()),
  );

  // Use cases
  sl.registerLazySingleton<GetBalanceUseCase>(
    () => GetBalanceUseCase(sl<BalanceRepository>()),
  );

  // BLoCs
  sl.registerFactory<BalanceBloc>(
    () => BalanceBloc(getBalance: sl<GetBalanceUseCase>()),
  );

  // ==================== Funds ====================
  // Datasources
  sl.registerLazySingleton<FundRemoteDatasource>(
    () => FundRemoteDatasourceImpl(sl<ApiClient>()),
  );

  // Repositories
  sl.registerLazySingleton<FundRepository>(
    () => FundRepositoryImpl(sl<FundRemoteDatasource>()),
  );

  // Use cases
  sl.registerLazySingleton<GetFundsUseCase>(
    () => GetFundsUseCase(sl<FundRepository>()),
  );

  sl.registerLazySingleton<SubscribeToFundUseCase>(
    () => SubscribeToFundUseCase(
      sl<FundRepository>(),
      sl<PortfolioRepository>(),
    ),
  );

  // BLoCs
  sl.registerFactory<FundBloc>(
    () => FundBloc(
      getFunds: sl<GetFundsUseCase>(),
      subscribeToFund: sl<SubscribeToFundUseCase>(),
    ),
  );

  // ==================== Portfolio ====================
  // Datasources
  sl.registerLazySingleton<PortfolioRemoteDatasource>(
    () => PortfolioRemoteDatasourceImpl(sl<ApiClient>()),
  );

  // Repositories
  sl.registerLazySingleton<PortfolioRepository>(
    () => PortfolioRepositoryImpl(sl<PortfolioRemoteDatasource>()),
  );

  // Use cases
  sl.registerLazySingleton<GetActiveSubscriptionsUseCase>(
    () => GetActiveSubscriptionsUseCase(sl<PortfolioRepository>()),
  );

  sl.registerLazySingleton<CancelSubscriptionUseCase>(
    () => CancelSubscriptionUseCase(sl<PortfolioRepository>()),
  );

  // BLoCs
  sl.registerFactory<PortfolioBloc>(
    () => PortfolioBloc(
      getActiveSubscriptions: sl<GetActiveSubscriptionsUseCase>(),
      cancelSubscription: sl<CancelSubscriptionUseCase>(),
    ),
  );

  // ==================== Transactions ====================
  // Datasources
  sl.registerLazySingleton<TransactionRemoteDatasource>(
    () => TransactionRemoteDatasourceImpl(sl<ApiClient>()),
  );

  // Repositories
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(sl<TransactionRemoteDatasource>()),
  );

  // Use cases
  sl.registerLazySingleton<GetTransactionsUseCase>(
    () => GetTransactionsUseCase(sl<TransactionRepository>()),
  );

  // BLoCs
  sl.registerFactory<TransactionBloc>(
    () => TransactionBloc(getTransactions: sl<GetTransactionsUseCase>()),
  );
}
