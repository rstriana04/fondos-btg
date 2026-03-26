import 'package:fondos_btg/core/error/exceptions.dart';
import 'package:fondos_btg/core/network/api_client.dart';
import 'package:fondos_btg/features/portfolio/data/models/subscription_dto.dart';

abstract class PortfolioRemoteDatasource {
  Future<List<SubscriptionDto>> getActiveSubscriptions();
  Future<double> cancelSubscription({required int subscriptionId});
}

class PortfolioRemoteDatasourceImpl implements PortfolioRemoteDatasource {
  final ApiClient _apiClient;

  const PortfolioRemoteDatasourceImpl(this._apiClient);

  @override
  Future<List<SubscriptionDto>> getActiveSubscriptions() async {
    try {
      // Get user's subscribed fund IDs
      final userResponse = await _apiClient.get('/user');
      final userData = userResponse.data as Map<String, dynamic>;
      final subscribedFundIds =
          List<String>.from(userData['subscribedFunds'] as List? ?? []);

      if (subscribedFundIds.isEmpty) return [];

      // Get all funds to cross-reference
      final fundsResponse = await _apiClient.get('/funds');
      final fundsData = fundsResponse.data as List<dynamic>;

      // Get transactions to find subscription dates
      final txResponse = await _apiClient.get('/transactions');
      final txData = txResponse.data as List<dynamic>;

      final subscriptions = <SubscriptionDto>[];
      for (final fundIdStr in subscribedFundIds) {
        final fund = fundsData.cast<Map<String, dynamic>>().where(
            (f) => f['id'].toString() == fundIdStr).firstOrNull;
        if (fund == null) continue;

        final fundId = int.parse(fundIdStr);

        // Find the latest subscription transaction for this fund
        final subTx = txData
            .cast<Map<String, dynamic>>()
            .where((t) =>
                t['fundId'].toString() == fundIdStr &&
                t['type'] == 'subscription')
            .toList()
          ..sort((a, b) => (b['date'] as String).compareTo(a['date'] as String));

        final subscribedAt = subTx.isNotEmpty
            ? subTx.first['date'] as String
            : DateTime.now().toIso8601String();

        subscriptions.add(SubscriptionDto(
          id: fundId,
          fundId: fundId,
          fundName: fund['name'] as String,
          category: fund['category'] as String,
          amount: (fund['minAmount'] as num).toDouble(),
          subscribedAt: subscribedAt,
        ));
      }

      return subscriptions;
    } catch (e) {
      if (e is ServerException || e is NotFoundException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<double> cancelSubscription({required int subscriptionId}) async {
    try {
      // Get fund info to know the amount
      final fundResponse = await _apiClient.get('/funds/$subscriptionId');
      final fundData = fundResponse.data as Map<String, dynamic>;
      final amount = (fundData['minAmount'] as num).toDouble();

      // Get current user data
      final userResponse = await _apiClient.get('/user');
      final userData = userResponse.data as Map<String, dynamic>;
      final currentBalance = (userData['balance'] as num).toDouble();
      final subscribedFunds =
          List<String>.from(userData['subscribedFunds'] as List? ?? []);

      final newBalance = currentBalance + amount;

      // Record cancellation transaction
      await _apiClient.post('/transactions', data: {
        'type': 'cancellation',
        'fundId': subscriptionId.toString(),
        'amount': amount,
        'notification': '',
        'date': DateTime.now().toUtc().toIso8601String(),
      });

      // Remove fund from subscribed funds and update balance
      subscribedFunds.remove(subscriptionId.toString());
      await _apiClient.patch('/user', data: {
        'balance': newBalance,
        'subscribedFunds': subscribedFunds,
      });

      return newBalance;
    } catch (e) {
      if (e is ServerException || e is NotFoundException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
