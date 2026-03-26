import 'package:fondos_btg/core/error/exceptions.dart';
import 'package:fondos_btg/core/network/api_client.dart';
import 'package:fondos_btg/features/funds/data/models/fund_dto.dart';

abstract class FundRemoteDatasource {
  /// Fetches all available funds from the API.
  Future<List<FundDto>> getFunds();

  /// Subscribes a user to a fund.
  /// Returns the updated balance.
  Future<double> subscribeToFund({
    required int fundId,
    required double amount,
    required String notificationMethod,
  });
}

class FundRemoteDatasourceImpl implements FundRemoteDatasource {
  final ApiClient _apiClient;

  const FundRemoteDatasourceImpl(this._apiClient);

  @override
  Future<List<FundDto>> getFunds() async {
    try {
      final response = await _apiClient.get('/funds');
      final data = response.data as List<dynamic>;
      return data
          .map((json) => FundDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ServerException || e is NotFoundException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<double> subscribeToFund({
    required int fundId,
    required double amount,
    required String notificationMethod,
  }) async {
    try {
      final response = await _apiClient.post(
        '/subscriptions',
        data: {
          'fundId': fundId,
          'amount': amount,
          'notificationMethod': notificationMethod,
        },
      );
      final data = response.data as Map<String, dynamic>;
      return (data['newBalance'] as num).toDouble();
    } catch (e) {
      if (e is ServerException ||
          e is NotFoundException ||
          e is BadRequestException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
