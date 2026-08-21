import 'package:get/get.dart';
import 'package:miiincare/features/cart/model/cart_model.dart';
import 'package:miiincare/features/cart/service/cart_service.dart';

class CartController extends GetxController {
  CartController({CartService? service}) : _service = service ?? CartService();
  final CartService _service;
  final cart = CartModel.empty.obs;
  final isLoading = false.obs;
  final updatingIds = <String>{}.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = '';
    try {
      cart.value = await _service.getCart();
    } catch (_) {
      error.value = 'Could not load your bag.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> add(int productId) async {
    isLoading.value = true;
    try {
      cart.value = await _service.addItem(productId);
      return true;
    } catch (e) {
      Get.snackbar(
        'Could not add to bag',
        e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeQuantity(CartItemModel item, int quantity) async {
    if (quantity < 1 || quantity > item.stock) return;
    updatingIds.add(item.id);
    try {
      cart.value = await _service.updateItem(item.id, quantity);
    } finally {
      updatingIds.remove(item.id);
    }
  }

  Future<void> remove(CartItemModel item) async {
    updatingIds.add(item.id);
    try {
      cart.value = await _service.removeItem(item.id);
    } finally {
      updatingIds.remove(item.id);
    }
  }
}
