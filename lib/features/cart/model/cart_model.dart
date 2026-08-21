class CartModel {
  const CartModel({
    required this.items,
    required this.itemCount,
    required this.subtotal,
    required this.discount,
    required this.shipping,
    required this.total,
  });
  final List<CartItemModel> items;
  final int itemCount;
  final double subtotal;
  final double discount;
  final double shipping;
  final double total;

  static const empty = CartModel(
    items: [],
    itemCount: 0,
    subtotal: 0,
    discount: 0,
    shipping: 0,
    total: 0,
  );

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'])
        : json;
    final rawItems = data['items'] is List ? data['items'] as List : const [];
    return CartModel(
      items: rawItems
          .whereType<Map>()
          .map(
            (item) => CartItemModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
      itemCount: int.tryParse('${data['itemCount'] ?? 0}') ?? 0,
      subtotal: double.tryParse('${data['subtotal'] ?? 0}') ?? 0,
      discount: double.tryParse('${data['discount'] ?? 0}') ?? 0,
      shipping: double.tryParse('${data['shipping'] ?? 0}') ?? 0,
      total: double.tryParse('${data['total'] ?? 0}') ?? 0,
    );
  }
}

class CartItemModel {
  const CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
    required this.lineTotal,
    required this.stock,
  });
  final String id;
  final int productId;
  final String name;
  final double price;
  final String image;
  final int quantity;
  final double lineTotal;
  final int stock;

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
    id: '${json['id'] ?? ''}',
    productId: int.tryParse('${json['productId'] ?? 0}') ?? 0,
    name: '${json['name'] ?? ''}',
    price: double.tryParse('${json['price'] ?? 0}') ?? 0,
    image: '${json['image'] ?? ''}',
    quantity: int.tryParse('${json['quantity'] ?? 0}') ?? 0,
    lineTotal: double.tryParse('${json['lineTotal'] ?? 0}') ?? 0,
    stock: int.tryParse('${json['stock'] ?? 0}') ?? 0,
  );
}
