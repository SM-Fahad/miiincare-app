import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miiincare/features/catalog/model/product_model.dart';
import 'package:miiincare/features/catalog/service/catalog_service.dart';

class ProductController extends GetxController {
  ProductController(this.initialProduct, {CatalogService? service})
    : _service = service ?? CatalogService();

  final ProductModel initialProduct;
  final CatalogService _service;
  late final product = initialProduct.obs;
  final selectedImage = 0.obs;
  final galleryPageController = PageController();
  final isLoading = false.obs;

  List<String> get gallery => product.value.images.isNotEmpty
      ? product.value.images
      : product.value.image.isEmpty
      ? const []
      : [product.value.image];

  @override
  void onInit() {
    super.onInit();
    loadDetails();
  }

  Future<void> loadDetails() async {
    isLoading.value = true;
    try {
      product.value = await _service.getProduct(initialProduct.slug);
    } finally {
      isLoading.value = false;
    }
  }

  void onImageChanged(int index) => selectedImage.value = index;

  Future<void> selectImage(int index) async {
    selectedImage.value = index;
    if (!galleryPageController.hasClients) return;
    await galleryPageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void onClose() {
    galleryPageController.dispose();
    super.onClose();
  }
}
