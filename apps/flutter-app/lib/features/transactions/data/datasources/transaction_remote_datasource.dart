import 'package:fondos_btg/core/error/exceptions.dart';
import 'package:fondos_btg/core/network/api_client.dart';
import 'package:fondos_btg/features/transactions/data/models/transaction_dto.dart';

abstract class TransactionRemoteDatasource {
  Future<List<TransactionDto>> getTransactions();
}

class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
  final ApiClient _apiClient;

  const TransactionRemoteDatasourceImpl(this._apiClient);

  @override
  Future<List<TransactionDto>> getTransactions() async {
    try {
      final txResponse = await _apiClient.get('/transactions');
      final txData = txResponse.data as List<dynamic>;

      // Get funds to resolve names
      final fundsResponse = await _apiClient.get('/funds');
      final fundsData = fundsResponse.data as List<dynamic>;
      final fundsMap = <String, Map<String, dynamic>>{};
      for (final f in fundsData) {
        final fund = f as Map<String, dynamic>;
        fundsMap[fund['id'].toString()] = fund;
      }

      final dtos = txData.map((json) {
        final dto = TransactionDto.fromJson(json as Map<String, dynamic>);
        final fund = fundsMap[dto.fundId];
        return dto.copyWith(
          fundName: fund?['name'] as String?,
          category: fund?['category'] as String?,
        );
      }).toList();

      // Sort by date descending (newest first)
      dtos.sort((a, b) => b.date.compareTo(a.date));

      return dtos;
    } catch (e) {
      if (e is ServerException || e is NotFoundException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
