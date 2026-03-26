import 'package:fondos_btg/core/error/exceptions.dart';
import 'package:fondos_btg/core/network/api_client.dart';
import 'package:fondos_btg/features/funds/data/models/fund_dto.dart';

abstract class FundRemoteDatasource {
  Future<List<FundDto>> getFunds();
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
      // 1. Get current user data
      final userResponse = await _apiClient.get('/user');
      final userData = userResponse.data as Map<String, dynamic>;
      final currentBalance = (userData['balance'] as num).toDouble();
      final subscribedFunds =
          List<String>.from(userData['subscribedFunds'] as List? ?? []);

      final newBalance = currentBalance - amount;

      // 2. Record transaction
      await _apiClient.post('/transactions', data: {
        'type': 'subscription',
        'fundId': fundId.toString(),
        'amount': amount,
        'notification': notificationMethod,
        'date': DateTime.now().toUtc().toIso8601String(),
      });

      // 3. Update user balance and subscribed funds
      subscribedFunds.add(fundId.toString());
      await _apiClient.patch('/user', data: {
        'balance': newBalance,
        'subscribedFunds': subscribedFunds,
      });

      return newBalance;
    } catch (e) {
      if (e is ServerException ||
          e is NotFoundException ||
          e is BadRequestException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
