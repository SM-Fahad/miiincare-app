import 'package:get/get.dart';
import 'package:miiincare/features/orders/model/order_detail_model.dart';
import 'package:miiincare/features/orders/service/order_service.dart';

class OrderDetailController extends GetxController {
  OrderDetailController(this.orderId, {OrderService? service})
    : _service = service ?? OrderService();

  final String orderId;
  final OrderService _service;
  final order = Rxn<OrderDetailModel>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrder();
  }

  Future<void> loadOrder() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      order.value = await _service.getOrder(orderId);
    } catch (error) {
      errorMessage.value = error.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}
