import 'package:fondos_btg/core/error/exceptions.dart';
import 'package:fondos_btg/core/network/api_client.dart';
import 'package:fondos_btg/features/portfolio/data/models/subscription_dto.dart';

abstract class PortfolioRemoteDatasource {
  /// Fetches all active subscriptions from the API.
  Future<List<SubscriptionDto>> getActiveSubscriptions();

  /// Cancels an active subscription.
  /// Returns the restored balance amount.
  Future<double> cancelSubscription({required int subscriptionId});
}

class PortfolioRemoteDatasourceImpl implements PortfolioRemoteDatasource {
  final ApiClient _apiClient;

  const PortfolioRemoteDatasourceImpl(this._apiClient);

  @override
  Future<List<SubscriptionDto>> getActiveSubscriptions() async {
    try {
      final response = await _apiClient.get('/subscriptions');
      final data = response.data as List<dynamic>;
      return data
          .map((json) =>
              SubscriptionDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ServerException || e is NotFoundException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<double> cancelSubscription({required int subscriptionId}) async {
    try {
      final response = await _apiClient.delete(
        '/subscriptions/$subscriptionId',
      );
      final data = response.data as Map<String, dynamic>;
      return (data['newBalance'] as num).toDouble();
    } catch (e) {
      if (e is ServerException || e is NotFoundException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
