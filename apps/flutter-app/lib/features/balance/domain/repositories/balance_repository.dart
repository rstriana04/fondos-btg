import 'package:dartz/dartz.dart';
import 'package:fondos_btg/core/error/failures.dart';
import 'package:fondos_btg/features/balance/domain/entities/balance_info.dart';

abstract class BalanceRepository {
  /// Returns the current balance info for the user.
  Future<Either<Failure, BalanceInfo>> getBalance();
}
