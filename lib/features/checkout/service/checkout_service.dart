import 'package:miiincare/core/api_end_point/api_end_point.dart';
import 'package:miiincare/core/network_service/live_api_client.dart';
import 'package:miiincare/features/checkout/model/checkout_request_model.dart';
import 'package:miiincare/features/checkout/model/order_model.dart';

class CheckoutService {
  CheckoutService({LiveApiClient? client})
    : _client = client ?? LiveApiClient();
  final LiveApiClient _client;

  Future<OrderModel> placeOrder(CheckoutRequestModel request) async {
    final raw = await _client.post(ApiEndPoint.orders, request.toJson());
    if (raw is! Map) throw Exception('Invalid order response');
    return OrderModel.fromJson(Map<String, dynamic>.from(raw));
  }
}
