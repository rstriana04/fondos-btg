import 'package:fondos_btg/core/error/exceptions.dart';
import 'package:fondos_btg/core/network/api_client.dart';
import 'package:fondos_btg/features/transactions/data/models/transaction_dto.dart';

abstract class TransactionRemoteDatasource {
  /// Fetches all transactions from the API.
  Future<List<TransactionDto>> getTransactions();
}

class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
  final ApiClient _apiClient;

  const TransactionRemoteDatasourceImpl(this._apiClient);

  @override
  Future<List<TransactionDto>> getTransactions() async {
    try {
      final response = await _apiClient.get('/transactions');
      final data = response.data as List<dynamic>;
      return data
          .map((json) =>
              TransactionDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ServerException || e is NotFoundException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
