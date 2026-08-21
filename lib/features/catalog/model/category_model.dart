class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.slug,
    required this.name,
    this.icon = '',
    this.description = '',
    this.productCount = 0,
  });
  final int id;
  final String slug;
  final String name;
  final String icon;
  final String description;
  final int productCount;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: int.tryParse('${json['id'] ?? 0}') ?? 0,
    slug: '${json['slug'] ?? ''}',
    name: '${json['name'] ?? ''}',
    icon: '${json['icon'] ?? ''}',
    description: '${json['description'] ?? ''}',
    productCount: int.tryParse('${json['productCount'] ?? 0}') ?? 0,
  );
}
