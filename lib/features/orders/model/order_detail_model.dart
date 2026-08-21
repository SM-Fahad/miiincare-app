class OrderDetailModel {
  const OrderDetailModel({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.customer,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.items,
    required this.totals,
    required this.estimatedDelivery,
  });

  final String id;
  final String status;
  final String createdAt;
  final OrderCustomerModel customer;
  final OrderAddressModel shippingAddress;
  final String paymentMethod;
  final List<OrderItemModel> items;
  final OrderTotalsModel totals;
  final String estimatedDelivery;

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'])
        : json;
    return OrderDetailModel(
      id: '${data['id'] ?? ''}',
      status: '${data['status'] ?? ''}',
      createdAt: '${data['createdAt'] ?? ''}',
      customer: OrderCustomerModel.fromJson(_map(data['customer'])),
      shippingAddress: OrderAddressModel.fromJson(
        _map(data['shippingAddress']),
      ),
      paymentMethod: '${data['paymentMethod'] ?? ''}',
      items: (data['items'] is List ? data['items'] as List : const [])
          .whereType<Map>()
          .map(
            (item) => OrderItemModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
      totals: OrderTotalsModel.fromJson(_map(data['totals'])),
      estimatedDelivery: '${data['estimatedDelivery'] ?? ''}',
    );
  }

  static Map<String, dynamic> _map(dynamic value) => value is Map
      ? Map<String, dynamic>.from(value)
      : const <String, dynamic>{};
}

class OrderCustomerModel {
  const OrderCustomerModel({
    required this.name,
    required this.email,
    required this.phone,
  });

  final String name;
  final String email;
  final String phone;

  factory OrderCustomerModel.fromJson(Map<String, dynamic> json) =>
      OrderCustomerModel(
        name: '${json['name'] ?? ''}',
        email: '${json['email'] ?? ''}',
        phone: '${json['phone'] ?? ''}',
      );
}

class OrderAddressModel {
  const OrderAddressModel({
    required this.address,
    required this.apartment,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  final String address;
  final String apartment;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  List<String> get lines => [
    address,
    apartment,
    [city, state, postalCode].where((part) => part.isNotEmpty).join(', '),
    country,
  ].where((line) => line.isNotEmpty).toList();

  factory OrderAddressModel.fromJson(Map<String, dynamic> json) =>
      OrderAddressModel(
        address: '${json['address'] ?? ''}',
        apartment: '${json['apartment'] ?? ''}',
        city: '${json['city'] ?? ''}',
        state: '${json['state'] ?? ''}',
        postalCode: '${json['postalCode'] ?? ''}',
        country: '${json['country'] ?? ''}',
      );
}

class OrderItemModel {
  const OrderItemModel({
    required this.id,
    required this.name,
    required this.image,
    required this.size,
    required this.quantity,
    required this.price,
    required this.total,
  });

  final String id;
  final String name;
  final String image;
  final String size;
  final int quantity;
  final double price;
  final double total;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'] is Map
        ? Map<String, dynamic>.from(json['product'])
        : const <String, dynamic>{};
    final quantity = int.tryParse('${json['quantity'] ?? 1}') ?? 1;
    final price = _number(json['price'] ?? product['price']);
    return OrderItemModel(
      id: '${json['id'] ?? product['id'] ?? ''}',
      name: '${json['name'] ?? product['name'] ?? ''}',
      image:
          '${json['image'] ?? json['imageUrl'] ?? product['image'] ?? product['imageUrl'] ?? ''}',
      size: '${json['size'] ?? product['size'] ?? ''}',
      quantity: quantity,
      price: price,
      total: _number(
        json['total'] ?? json['lineTotal'] ?? json['subtotal'],
        fallback: price * quantity,
      ),
    );
  }
}

class OrderTotalsModel {
  const OrderTotalsModel({
    required this.subtotal,
    required this.discount,
    required this.shipping,
    required this.tax,
    required this.total,
  });

  final double subtotal;
  final double discount;
  final double shipping;
  final double tax;
  final double total;

  factory OrderTotalsModel.fromJson(Map<String, dynamic> json) =>
      OrderTotalsModel(
        subtotal: _number(json['subtotal']),
        discount: _number(json['discount']),
        shipping: _number(json['shipping']),
        tax: _number(json['tax']),
        total: _number(json['total']),
      );
}

double _number(dynamic value, {double fallback = 0}) =>
    double.tryParse('$value') ?? fallback;
