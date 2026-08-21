import 'package:miiincare/features/catalog/model/product_model.dart';

class ProductListModel {
  const ProductListModel({
    required this.items,
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
  });
  final List<ProductModel> items;
  final int page;
  final int perPage;
  final int total;
  final int totalPages;

  factory ProductListModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'])
        : json;
    final rawItems = data['items'] is List ? data['items'] as List : const [];
    final meta = data['meta'] is Map
        ? Map<String, dynamic>.from(data['meta'])
        : const <String, dynamic>{};
    return ProductListModel(
      items: rawItems
          .whereType<Map>()
          .map((item) => ProductModel.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
      page: int.tryParse('${meta['page'] ?? 1}') ?? 1,
      perPage:
          int.tryParse('${meta['perPage'] ?? rawItems.length}') ??
          rawItems.length,
      total:
          int.tryParse('${meta['total'] ?? rawItems.length}') ??
          rawItems.length,
      totalPages: int.tryParse('${meta['totalPages'] ?? 1}') ?? 1,
    );
  }
}
