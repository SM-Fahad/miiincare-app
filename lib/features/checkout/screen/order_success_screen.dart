import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miiincare/core/constants/app_color.dart';
import 'package:miiincare/features/checkout/model/order_model.dart';
import 'package:miiincare/routes/app_routes.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final order = Get.arguments as OrderModel;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 42,
                backgroundColor: AppColor.softLavender,
                child: Icon(
                  Icons.check_rounded,
                  size: 48,
                  color: AppColor.success,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Order confirmed!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Text(
                'Thank you, ${order.customerName}. Your order has been placed successfully.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColor.muted, height: 1.5),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColor.softLavender,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _OrderRow(label: 'Order ID', value: order.id),
                    _OrderRow(label: 'Payment', value: 'Cash on delivery'),
                    _OrderRow(
                      label: 'Total',
                      value: 'BDT ${order.total.toStringAsFixed(0)}',
                    ),
                    if (order.estimatedDelivery.isNotEmpty)
                      _OrderRow(
                        label: 'Estimated delivery',
                        value: order.estimatedDelivery,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: () => Get.offAllNamed(AppRoutes.home),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                ),
                child: const Text('Continue shopping'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Text(label, style: const TextStyle(color: AppColor.muted)),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
}
