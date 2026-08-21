import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miiincare/core/constants/app_color.dart';
import 'package:miiincare/features/orders/controller/order_detail_controller.dart';
import 'package:miiincare/features/orders/model/order_detail_model.dart';
import 'package:miiincare/routes/app_routes.dart';

class OrderDetailScreen extends StatelessWidget {
  OrderDetailScreen({super.key, required this.orderId})
    : controller = Get.put(OrderDetailController(orderId), tag: orderId);

  final String orderId;
  final OrderDetailController controller;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Order details')),
    body: Obx(() {
      if (controller.isLoading.value && controller.order.value == null) {
        return const Center(child: CircularProgressIndicator());
      }
      final order = controller.order.value;
      if (order == null) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 42),
                const SizedBox(height: 12),
                Text(
                  controller.errorMessage.value.isEmpty
                      ? 'Could not load this order.'
                      : controller.errorMessage.value,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: controller.loadOrder,
                  child: const Text('TRY AGAIN'),
                ),
              ],
            ),
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: controller.loadOrder,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          children: [
            const CircleAvatar(
              radius: 32,
              backgroundColor: AppColor.softLavender,
              child: Icon(Icons.check, color: AppColor.primary, size: 32),
            ),
            const SizedBox(height: 18),
            Text(
              'Thank you${order.customer.name.isEmpty ? '' : ', ${_firstName(order.customer.name)}'}!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Your order ${order.id} is ${order.status.toLowerCase()}.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColor.muted),
            ),
            if (order.customer.email.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(
                'A receipt is on its way to ${order.customer.email}.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColor.muted),
              ),
            ],
            const SizedBox(height: 28),
            _OrderSection(
              title: 'ITEMS',
              child: Column(
                children: [
                  for (var index = 0; index < order.items.length; index++) ...[
                    _OrderItem(item: order.items[index]),
                    if (index != order.items.length - 1)
                      const Divider(height: 24, color: AppColor.border),
                  ],
                  if (order.items.isEmpty)
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('No item details available.'),
                    ),
                  const Divider(height: 28, color: AppColor.border),
                  _MoneyRow(label: 'Subtotal', value: order.totals.subtotal),
                  if (order.totals.discount > 0)
                    _MoneyRow(label: 'Discount', value: -order.totals.discount),
                  _MoneyRow(
                    label: 'Shipping',
                    value: order.totals.shipping,
                    freeWhenZero: true,
                  ),
                  if (order.totals.tax > 0)
                    _MoneyRow(label: 'Tax', value: order.totals.tax),
                  const Divider(height: 24, color: AppColor.border),
                  _MoneyRow(
                    label: 'Total',
                    value: order.totals.total,
                    bold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _OrderSection(
              title: 'DELIVERY',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (order.customer.name.isNotEmpty)
                    Text(
                      order.customer.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  for (final line in order.shippingAddress.lines) ...[
                    const SizedBox(height: 4),
                    Text(line, style: const TextStyle(color: AppColor.muted)),
                  ],
                  if (order.customer.phone.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      order.customer.phone,
                      style: const TextStyle(color: AppColor.muted),
                    ),
                  ],
                  if (order.estimatedDelivery.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    _InfoRow(
                      icon: Icons.local_shipping_outlined,
                      label: 'Estimated delivery',
                      value: _displayDate(order.estimatedDelivery),
                    ),
                  ],
                  if (order.paymentMethod.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.sell_outlined,
                      label: 'Payment',
                      value: order.paymentMethod.toUpperCase(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Get.offAllNamed(AppRoutes.home),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('CONTINUE SHOPPING'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
              ),
            ),
          ],
        ),
      );
    }),
  );
}

class _OrderSection extends StatelessWidget {
  const _OrderSection({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: AppColor.surface,
      border: Border.all(color: AppColor.border),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 18),
        child,
      ],
    ),
  );
}

class _OrderItem extends StatelessWidget {
  const _OrderItem({required this.item});
  final OrderItemModel item;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 62,
        height: 62,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColor.background,
          border: Border.all(color: AppColor.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: item.image.isEmpty
            ? const Icon(Icons.image_outlined, color: AppColor.muted)
            : Image.network(
                item.image,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColor.muted,
                ),
              ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            if (item.size.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(item.size, style: const TextStyle(color: AppColor.muted)),
            ],
            const SizedBox(height: 4),
            Text(
              'Quantity: ${item.quantity}',
              style: const TextStyle(color: AppColor.muted),
            ),
          ],
        ),
      ),
      const SizedBox(width: 8),
      Text(
        'BDT ${item.total.toStringAsFixed(0)}',
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ],
  );
}

class _MoneyRow extends StatelessWidget {
  const _MoneyRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.freeWhenZero = false,
  });
  final String label;
  final double value;
  final bool bold;
  final bool freeWhenZero;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: bold ? FontWeight.w800 : null),
        ),
        const Spacer(),
        Text(
          freeWhenZero && value == 0
              ? 'Free'
              : '${value < 0 ? '-' : ''}BDT ${value.abs().toStringAsFixed(0)}',
          style: TextStyle(fontWeight: bold ? FontWeight.w800 : null),
        ),
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 18, color: AppColor.primary),
      const SizedBox(width: 8),
      Text('$label  ', style: const TextStyle(color: AppColor.muted)),
      Expanded(
        child: Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    ],
  );
}

String _firstName(String name) => name.trim().split(RegExp(r'\s+')).first;

String _displayDate(String value) {
  final date = DateTime.tryParse(value);
  if (date == null) return value;
  return '${date.day}/${date.month}/${date.year}';
}
