import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miiincare/features/auth/account/controller/auth_controller.dart';
import 'package:miiincare/routes/app_routes.dart';

class AuthFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final obscurePassword = true.obs;

  AuthController get auth => Get.find<AuthController>();
  void togglePassword() => obscurePassword.toggle();
  String? requiredField(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required' : null;
  String? emailValidator(String? value) {
    final required = requiredField(value);
    if (required != null) {
      return required;
    }
    return GetUtils.isEmail(value!.trim()) ? null : 'Enter a valid email';
  }

  Future<void> submitLogin() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (await auth.login(email.text.trim(), password.text)) {
      Get.offAllNamed(AppRoutes.home);
    }
  }

  Future<void> submitRegister() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (password.text != confirmPassword.text) {
      Get.snackbar(
        'Passwords do not match',
        'Please enter the same password twice.',
      );
      return;
    }
    if (await auth.register(
      name.text.trim(),
      email.text.trim(),
      password.text,
    )) {
      Get.offAllNamed(AppRoutes.home);
    }
  }

  @override
  void onClose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.onClose();
  }
}
