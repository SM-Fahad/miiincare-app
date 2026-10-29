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

  // Home section product lists
  final bestSellers = <ProductModel>[].obs;
  final combos = <ProductModel>[].obs;
  final skinCare = <ProductModel>[].obs;
  final serums = <ProductModel>[].obs;
  final faceWash = <ProductModel>[].obs;
  final hairCare = <ProductModel>[].obs;
  final bodyEssentials = <ProductModel>[].obs;
  final supplements = <ProductModel>[].obs;
  final eyeCare = <ProductModel>[].obs;
  final sectionsLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    sectionsLoading.value = true;
    error.value = '';
    try {
      final result = await Future.wait([
        _service.getProducts(),
        _service.getCategories(),
      ]);
      products.assignAll(result[0] as List<ProductModel>);
      categories.assignAll(result[1] as List<CategoryModel>);
      isLoading.value = false;

      await loadHomeSections();
    } catch (e) {
      error.value =
          'Could not load products. Check your connection and try again.';
      isLoading.value = false;
      sectionsLoading.value = false;
    }
  }

  Future<void> loadHomeSections() async {
    sectionsLoading.value = true;
    try {
      final sectionResults = await Future.wait([
        _service.getBestSellers(perPage: 10),
        _service.getCombos(perPage: 10),
        _service.getCategoryProducts('skin-care', perPage: 10),
        _service.getCategoryProducts('serum', perPage: 10),
        _service.getCategoryProducts('face-wash', perPage: 10),
        _service.getCategoryProducts('hair-care', perPage: 10),
        _service.getCategoryProducts('body-essentials', perPage: 10),
        _service.getCategoryProducts('supplements', perPage: 10),
        _service.getCategoryProducts('eye-care', perPage: 10),
      ]);

      bestSellers.assignAll(sectionResults[0]);
      combos.assignAll(sectionResults[1]);
      skinCare.assignAll(sectionResults[2]);
      serums.assignAll(sectionResults[3]);
      faceWash.assignAll(sectionResults[4]);
      hairCare.assignAll(sectionResults[5]);
      bodyEssentials.assignAll(sectionResults[6]);
      supplements.assignAll(sectionResults[7]);
      eyeCare.assignAll(sectionResults[8]);
    } catch (_) {
      // Graceful fallback: individual section failure will not break the screen
    } finally {
      sectionsLoading.value = false;
    }
  }

  Future<void> selectCategoryAndFilter(String slug) async {
    final cat = categories.firstWhereOrNull((c) => c.slug == slug);
    if (cat != null) {
      await filterBy(cat);
    } else {
      selectedCategorySlug.value = slug;
      await filterBy(CategoryModel(id: 0, slug: slug, name: slug));
    }
  }

  Future<void> selectBundleAndFilter() async {
    selectedCategorySlug.value = '';
    isLoading.value = true;
    error.value = '';
    try {
      products.assignAll(
        await _service.getProducts(bundle: true, sort: 'featured', perPage: 40),
      );
    } catch (_) {
      error.value = 'Could not load combo packs.';
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
          perPage: 40,
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
