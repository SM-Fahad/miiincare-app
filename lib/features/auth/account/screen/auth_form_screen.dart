import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miiincare/core/constants/app_color.dart';
import 'package:miiincare/core/constants/image_path.dart';
import 'package:miiincare/features/auth/account/controller/auth_controller.dart';
import 'package:miiincare/features/auth/account/controller/auth_form_controller.dart';
import 'package:miiincare/routes/app_routes.dart';

class AuthFormScreen extends StatelessWidget {
  AuthFormScreen({super.key, required this.isRegister});
  final bool isRegister;
  late final AuthFormController controller = Get.put(
    AuthFormController(),
    tag: isRegister ? 'register' : 'login',
  );

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: AppColor.softLavender,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColor.border),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  Image.asset(ImagePath.splashIcon, width: 58, height: 58),
                  const SizedBox(height: 18),
                  Text(
                    isRegister ? 'Create your account' : 'Welcome back',
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isRegister
                        ? 'Save your details for faster checkout and track every order.'
                        : 'Sign in to see your orders and saved addresses.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColor.muted),
                  ),
                  const SizedBox(height: 24),
                  if (isRegister)
                    _AuthField(
                      label: 'Name',
                      controller: controller.name,
                      validator: controller.requiredField,
                    ),
                  _AuthField(
                    label: 'Email',
                    controller: controller.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: controller.emailValidator,
                  ),
                  Obx(
                    () => _AuthField(
                      label: 'Password',
                      controller: controller.password,
                      obscureText: controller.obscurePassword.value,
                      validator: controller.requiredField,
                      suffix: IconButton(
                        onPressed: controller.togglePassword,
                        icon: Icon(
                          controller.obscurePassword.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                  ),
                  if (isRegister)
                    Obx(
                      () => _AuthField(
                        label: 'Re-enter password',
                        controller: controller.confirmPassword,
                        obscureText: controller.obscurePassword.value,
                        validator: controller.requiredField,
                      ),
                    ),
                  Obx(
                    () => auth.error.isEmpty
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              auth.error.value,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ),
                  Obx(
                    () => FilledButton(
                      onPressed: auth.isSubmitting.value
                          ? null
                          : isRegister
                          ? controller.submitRegister
                          : controller.submitLogin,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                      ),
                      child: auth.isSubmitting.value
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(isRegister ? 'CREATE ACCOUNT' : 'SIGN IN'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Get.offNamed(
                      isRegister ? AppRoutes.login : AppRoutes.register,
                    ),
                    child: Text(
                      isRegister
                          ? 'Already have an account? Sign in'
                          : 'New to Miiincare? Create an account',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.suffix,
  });
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? suffix;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColor.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColor.border),
        ),
      ),
    ),
  );
}
