import 'package:miiincare/core/api_end_point/api_end_point.dart';
import 'package:miiincare/core/network_service/live_api_client.dart';
import 'package:miiincare/features/cart/model/cart_model.dart';

class CartService {
  CartService({LiveApiClient? client}) : _client = client ?? LiveApiClient();
  final LiveApiClient _client;

  Future<CartModel> getCart() async =>
      _parse(await _client.get(ApiEndPoint.cart));
  Future<CartModel> addItem(int productId, {int quantity = 1}) async => _parse(
    await _client.post(ApiEndPoint.cartItems, {
      'productId': productId,
      'quantity': quantity,
    }),
  );
  Future<CartModel> updateItem(String id, int quantity) async => _parse(
    await _client.patch(ApiEndPoint.cartItem(id), {'quantity': quantity}),
  );
  Future<CartModel> removeItem(String id) async =>
      _parse(await _client.delete(ApiEndPoint.cartItem(id)));

  CartModel _parse(dynamic raw) {
    if (raw is! Map) throw Exception('Invalid cart response');
    return CartModel.fromJson(Map<String, dynamic>.from(raw));
  }
}
