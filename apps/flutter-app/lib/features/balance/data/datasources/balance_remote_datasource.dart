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
      final response = await _apiClient.get('/balance');
      final data = response.data as Map<String, dynamic>;
      return BalanceInfo(
        balance: (data['balance'] as num).toDouble(),
        investedAmount: (data['investedAmount'] as num).toDouble(),
      );
    } catch (e) {
      if (e is ServerException || e is NotFoundException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
