class AccountOrderModel {
  const AccountOrderModel({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.total,
    required this.itemCount,
  });
  final String id;
  final String status;
  final String createdAt;
  final double total;
  final int itemCount;

  factory AccountOrderModel.fromJson(Map<String, dynamic> json) {
    final totals = json['totals'] is Map
        ? Map<String, dynamic>.from(json['totals'])
        : const <String, dynamic>{};
    final items = json['items'] is List ? json['items'] as List : const [];
    return AccountOrderModel(
      id: '${json['id'] ?? ''}',
      status: '${json['status'] ?? ''}',
      createdAt: '${json['createdAt'] ?? ''}',
      total: double.tryParse('${totals['total'] ?? json['total'] ?? 0}') ?? 0,
      itemCount: items.fold<int>(
        0,
        (sum, item) =>
            sum +
            (item is Map ? int.tryParse('${item['quantity'] ?? 1}') ?? 1 : 0),
      ),
    );
  }
}
