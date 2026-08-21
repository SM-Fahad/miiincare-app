import 'package:miiincare/core/api_end_point/api_end_point.dart';
import 'package:miiincare/core/network_service/live_api_client.dart';
import 'package:miiincare/features/orders/model/order_detail_model.dart';

class OrderService {
  OrderService({LiveApiClient? client}) : _client = client ?? LiveApiClient();

  final LiveApiClient _client;

  Future<OrderDetailModel> getOrder(String orderId) async {
    final raw = await _client.get(ApiEndPoint.order(orderId));
    if (raw is! Map) throw Exception('Invalid order response');
    return OrderDetailModel.fromJson(Map<String, dynamic>.from(raw));
  }
}
