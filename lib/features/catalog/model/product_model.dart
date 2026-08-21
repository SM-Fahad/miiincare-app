class ProductModel {
  const ProductModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.price,
    this.compareAtPrice,
    this.tagline = '',
    this.category = '',
    this.image = '',
    this.images = const [],
    this.shortDescription = '',
    this.description = '',
    this.size = '',
    this.ingredients = const [],
    this.howToUse = '',
    this.benefits = const [],
    this.stock = 0,
    this.rating = 0,
    this.reviewCount = 0,
    this.isBestSeller = false,
  });

  final int id;
  final String slug;
  final String name;
  final double price;
  final double? compareAtPrice;
  final String tagline;
  final String category;
  final String image;
  final List<String> images;
  final String shortDescription;
  final String description;
  final String size;
  final List<String> ingredients;
  final String howToUse;
  final List<String> benefits;
  final int stock;
  final double rating;
  final int reviewCount;
  final bool isBestSeller;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: int.tryParse('${json['id'] ?? 0}') ?? 0,
    slug: '${json['slug'] ?? ''}',
    name: '${json['name'] ?? 'Skincare product'}',
    price: double.tryParse('${json['price'] ?? 0}') ?? 0,
    compareAtPrice: json['compareAtPrice'] == null
        ? null
        : double.tryParse('${json['compareAtPrice']}'),
    tagline: '${json['tagline'] ?? ''}',
    category: '${json['category'] ?? ''}',
    image: '${json['image'] ?? ''}',
    images: _stringsFromImages(json['images']),
    shortDescription: '${json['shortDescription'] ?? ''}',
    description: '${json['description'] ?? ''}',
    size: '${json['size'] ?? ''}',
    ingredients: _strings(json['ingredients']),
    howToUse: '${json['howToUse'] ?? ''}',
    benefits: _strings(json['benefits']),
    stock: int.tryParse('${json['stock'] ?? 0}') ?? 0,
    rating: double.tryParse('${json['rating'] ?? 0}') ?? 0,
    reviewCount: int.tryParse('${json['reviewCount'] ?? 0}') ?? 0,
    isBestSeller: json['isBestSeller'] == true,
  );

  static List<String> _strings(dynamic value) => value is List
      ? value.map((e) => '$e').where((e) => e.isNotEmpty).toList()
      : const [];

  static List<String> _stringsFromImages(dynamic value) => value is List
      ? value
            .whereType<Map>()
            .map((e) => '${e['url'] ?? ''}')
            .where((e) => e.isNotEmpty)
            .toList()
      : const [];
}
