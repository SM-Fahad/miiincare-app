import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miiincare/core/constants/app_color.dart';
import 'package:miiincare/features/cart/controller/cart_controller.dart';
import 'package:miiincare/features/checkout/controller/checkout_controller.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({super.key});
  final CheckoutController controller = Get.put(CheckoutController());
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: AppColor.background,
      title: const Text('Checkout'),
    ),
    body: Form(
      key: controller.formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          const Text(
            'CONTACT & DELIVERY',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 18),
          _CheckoutField(
            label: 'Email',
            controller: controller.email,
            keyboardType: TextInputType.emailAddress,
            validator: controller.validateEmail,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _CheckoutField(
                  label: 'First name',
                  controller: controller.firstName,
                  validator: controller.requiredField,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CheckoutField(
                  label: 'Last name',
                  controller: controller.lastName,
                  validator: controller.requiredField,
                ),
              ),
            ],
          ),
          _CheckoutField(
            label: 'Address',
            controller: controller.address,
            validator: controller.requiredField,
          ),
          _CheckoutField(
            label: 'Apartment, suite (optional)',
            controller: controller.apartment,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _CheckoutField(
                  label: 'District',
                  controller: controller.state,
                  validator: controller.requiredField,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CheckoutField(
                  label: 'City / Upazila',
                  controller: controller.city,
                  validator: controller.requiredField,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _CheckoutField(
                  label: 'Postcode',
                  controller: controller.postalCode,
                  keyboardType: TextInputType.number,
                  validator: controller.requiredField,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: _ReadOnlyField(label: 'Country', value: 'Bangladesh'),
              ),
            ],
          ),
          _CheckoutField(
            label: 'Phone number',
            controller: controller.phone,
            keyboardType: TextInputType.phone,
            validator: controller.requiredField,
          ),
          const SizedBox(height: 12),
          const Text(
            'PAYMENT',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.softLavender,
              border: Border.all(color: AppColor.primary),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.radio_button_checked,
                  color: AppColor.primary,
                  size: 20,
                ),
                SizedBox(width: 12),
                Icon(Icons.local_shipping_outlined, color: AppColor.primary),
                SizedBox(width: 10),
                Text(
                  'Cash on delivery',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _OrderSummary(controller: cartController),
          const SizedBox(height: 24),
          Obx(
            () => FilledButton(
              onPressed: controller.isSubmitting.value
                  ? null
                  : controller.submit,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
              ),
              child: controller.isSubmitting.value
                  ? const SizedBox.square(
                      dimension: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Place order · BDT ${cartController.cart.value.total.toStringAsFixed(0)}',
                    ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _CheckoutField extends StatelessWidget {
  const _CheckoutField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.validator,
  });
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.border),
        ),
      ),
    ),
  );
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColor.softLavender,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.border),
        ),
      ),
      child: Text(value),
    ),
  );
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.controller});
  final CartController controller;
  @override
  Widget build(BuildContext context) => Obx(() {
    final cart = controller.cart.value;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.softLavender.withValues(alpha: .55),
        border: Border.all(color: AppColor.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'YOUR ORDER',
            style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: .8),
          ),
          const SizedBox(height: 14),
          ...cart.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox.square(
                      dimension: 52,
                      child: Image.network(item.image, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${item.name}\nQty: ${item.quantity}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'BDT ${item.lineTotal.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: AppColor.border),
          _SummaryRow(label: 'Subtotal', value: cart.subtotal),
          _SummaryRow(label: 'Shipping', value: cart.shipping),
          const SizedBox(height: 6),
          _SummaryRow(label: 'Total', value: cart.total, bold: true),
        ],
      ),
    );
  });
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });
  final String label;
  final double value;
  final bool bold;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        const Spacer(),
        Text(
          value == 0 && label == 'Shipping'
              ? 'Free'
              : 'BDT ${value.toStringAsFixed(0)}',
          style: TextStyle(
            fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
