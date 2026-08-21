import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miiincare/features/cart/controller/cart_controller.dart';
import 'package:miiincare/features/checkout/model/checkout_request_model.dart';
import 'package:miiincare/features/checkout/service/checkout_service.dart';
import 'package:miiincare/routes/app_routes.dart';

class CheckoutController extends GetxController {
  CheckoutController({CheckoutService? service})
    : _service = service ?? CheckoutService();
  final CheckoutService _service;
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final address = TextEditingController();
  final apartment = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final postalCode = TextEditingController();
  final phone = TextEditingController();
  final isSubmitting = false.obs;

  String? requiredField(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required' : null;

  String? validateEmail(String? value) {
    final required = requiredField(value);
    if (required != null) return required;
    return GetUtils.isEmail(value!.trim())
        ? null
        : 'Enter a valid email address';
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    isSubmitting.value = true;
    try {
      final order = await _service.placeOrder(
        CheckoutRequestModel(
          email: email.text.trim(),
          firstName: firstName.text.trim(),
          lastName: lastName.text.trim(),
          address: address.text.trim(),
          apartment: apartment.text.trim(),
          city: city.text.trim(),
          state: state.text.trim(),
          postalCode: postalCode.text.trim(),
          country: 'Bangladesh',
          phone: phone.text.trim(),
        ),
      );
      if (Get.isRegistered<CartController>()) {
        await Get.find<CartController>().load();
      }
      Get.offNamed(AppRoutes.orderSuccess, arguments: order);
    } catch (e) {
      Get.snackbar(
        'Order could not be placed',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    for (final controller in [
      email,
      firstName,
      lastName,
      address,
      apartment,
      city,
      state,
      postalCode,
      phone,
    ]) {
      controller.dispose();
    }
    super.onClose();
  }
}
