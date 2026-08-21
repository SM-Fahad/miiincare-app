class OrderModel {
  const OrderModel({
    required this.id,
    required this.status,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.paymentMethod,
    required this.total,
    required this.estimatedDelivery,
  });
  final String id;
  final String status;
  final String customerName;
  final String phone;
  final String address;
  final String paymentMethod;
  final double total;
  final String estimatedDelivery;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'])
        : json;
    final customer = data['customer'] is Map
        ? Map<String, dynamic>.from(data['customer'])
        : const <String, dynamic>{};
    final shipping = data['shippingAddress'] is Map
        ? Map<String, dynamic>.from(data['shippingAddress'])
        : const <String, dynamic>{};
    final totals = data['totals'] is Map
        ? Map<String, dynamic>.from(data['totals'])
        : const <String, dynamic>{};
    return OrderModel(
      id: '${data['id'] ?? ''}',
      status: '${data['status'] ?? 'confirmed'}',
      customerName: '${customer['name'] ?? ''}',
      phone: '${customer['phone'] ?? ''}',
      address: [
        shipping['address'],
        shipping['apartment'],
        shipping['city'],
        shipping['state'],
      ].where((value) => value != null && '$value'.isNotEmpty).join(', '),
      paymentMethod: '${data['paymentMethod'] ?? 'cod'}',
      total: double.tryParse('${totals['total'] ?? data['total'] ?? 0}') ?? 0,
      estimatedDelivery: '${data['estimatedDelivery'] ?? ''}',
    );
  }
}
