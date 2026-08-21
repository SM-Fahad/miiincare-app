import 'package:miiincare/core/api_end_point/api_end_point.dart';
import 'package:miiincare/core/network_service/live_api_client.dart';
import 'package:miiincare/features/catalog/model/category_model.dart';
import 'package:miiincare/features/catalog/model/product_list_model.dart';
import 'package:miiincare/features/catalog/model/product_model.dart';

class CatalogService {
  CatalogService({LiveApiClient? client}) : _client = client ?? LiveApiClient();
  final LiveApiClient _client;

  Future<List<ProductModel>> getProducts({
    String? category,
    String? search,
    bool? bestSeller,
    String sort = 'featured',
    int page = 1,
    int perPage = 40,
  }) async {
    final query = <String, String>{
      if (category != null && category.isNotEmpty) 'category': category,
      if (search != null && search.isNotEmpty) 'search': search,
      if (bestSeller != null) 'bestSeller': '$bestSeller',
      'sort': sort,
      'page': '$page',
      'perPage': '$perPage',
    };
    final uri = Uri.parse(ApiEndPoint.products).replace(queryParameters: query);
    final raw = await _client.get(uri.toString());
    if (raw is! Map) return [];
    return ProductListModel.fromJson(Map<String, dynamic>.from(raw)).items;
  }

  Future<List<ProductModel>> getBestSellers() =>
      getProducts(bestSeller: true, perPage: 20);

  Future<List<CategoryModel>> getCategories() async {
    final raw = await _client.get(ApiEndPoint.categories);
    final data = raw is Map ? (raw['data'] ?? raw['items'] ?? raw) : raw;
    if (data is! List) return [];
    return data
        .whereType<Map>()
        .map((e) => CategoryModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<ProductModel> getProduct(String slug) async {
    final raw = await _client.get(ApiEndPoint.product(slug));
    final data = raw is Map ? (raw['data'] ?? raw) : raw;
    if (data is! Map) throw Exception('Invalid product response');
    return ProductModel.fromJson(Map<String, dynamic>.from(data));
  }
}
