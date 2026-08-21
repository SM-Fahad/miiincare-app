import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miiincare/features/catalog/model/category_model.dart';
import 'package:miiincare/features/catalog/model/product_model.dart';
import 'package:miiincare/features/catalog/service/catalog_service.dart';

class CatalogController extends GetxController {
  CatalogController({CatalogService? service})
    : _service = service ?? CatalogService();
  final CatalogService _service;
  final products = <ProductModel>[].obs;
  final categories = <CategoryModel>[].obs;
  final selectedCategorySlug = ''.obs;
  final isLoading = true.obs;
  final error = ''.obs;
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = '';
    try {
      final result = await Future.wait([
        _service.getProducts(),
        _service.getCategories(),
      ]);
      products.assignAll(result[0] as List<ProductModel>);
      categories.assignAll(result[1] as List<CategoryModel>);
    } catch (e) {
      error.value =
          'Could not load products. Check your connection and try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> filterBy(CategoryModel? category) async {
    selectedCategorySlug.value = category?.slug ?? '';
    isLoading.value = true;
    error.value = '';
    try {
      products.assignAll(
        await _service.getProducts(
          category: category?.slug,
          sort: 'featured',
          page: 1,
          perPage: 9,
        ),
      );
    } catch (_) {
      error.value = 'Could not load products for this category.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> search(String query) async {
    final value = query.trim();
    if (value.isEmpty) {
      await filterBy(
        categories.firstWhereOrNull(
          (category) => category.slug == selectedCategorySlug.value,
        ),
      );
      return;
    }
    isLoading.value = true;
    error.value = '';
    try {
      products.assignAll(
        await _service.getProducts(
          category: selectedCategorySlug.value,
          search: value,
          sort: 'featured',
        ),
      );
    } catch (_) {
      error.value = 'Could not search products.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> clearSearch() async {
    searchController.clear();
    await search('');
  }

  List<ProductModel> get visibleProducts => products;

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}
