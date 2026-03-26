import 'package:dartz/dartz.dart';
import 'package:fondos_btg/core/error/failures.dart';
import 'package:fondos_btg/features/funds/domain/entities/fund.dart';

abstract class FundRepository {
  /// Returns all available funds.
  Future<Either<Failure, List<Fund>>> getFunds();

  /// Subscribes a user to a fund.
  /// Returns the updated balance on success.
  Future<Either<Failure, double>> subscribeToFund({
    required int fundId,
    required double amount,
    required String notificationMethod,
  });
}
