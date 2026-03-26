import 'package:fondos_btg/core/error/exceptions.dart';
import 'package:fondos_btg/core/network/api_client.dart';
import 'package:fondos_btg/features/balance/domain/entities/balance_info.dart';

abstract class BalanceRemoteDatasource {
  /// Fetches the current balance info from the API.
  Future<BalanceInfo> getBalance();
}

class BalanceRemoteDatasourceImpl implements BalanceRemoteDatasource {
  final ApiClient _apiClient;

  const BalanceRemoteDatasourceImpl(this._apiClient);

  @override
  Future<BalanceInfo> getBalance() async {
    try {
      final response = await _apiClient.get('/user');
      final data = response.data as Map<String, dynamic>;
      final balance = (data['balance'] as num).toDouble();
      final subscribedFunds = data['subscribedFunds'] as List<dynamic>? ?? [];
      final investedAmount = subscribedFunds.fold<double>(
        0,
        (sum, item) {
          if (item is Map<String, dynamic>) {
            return sum + (item['amount'] as num? ?? 0).toDouble();
          }
          return sum;
        },
      );
      return BalanceInfo(
        balance: balance,
        investedAmount: investedAmount,
      );
    } catch (e) {
      if (e is ServerException || e is NotFoundException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
