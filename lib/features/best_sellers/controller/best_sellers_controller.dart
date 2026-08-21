import 'package:get/get.dart';
import 'package:miiincare/features/catalog/model/product_model.dart';
import 'package:miiincare/features/catalog/service/catalog_service.dart';

class BestSellersController extends GetxController {
  BestSellersController({CatalogService? service})
    : _service = service ?? CatalogService();

  final CatalogService _service;
  final products = <ProductModel>[].obs;
  final isLoading = true.obs;
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
      products.assignAll(await _service.getBestSellers());
    } catch (_) {
      error.value = 'Could not load best sellers. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }
}
