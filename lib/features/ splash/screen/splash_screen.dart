import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miiincare/core/constants/app_color.dart';
import 'package:miiincare/core/constants/image_path.dart';
import 'package:miiincare/routes/app_routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void>.delayed(const Duration(milliseconds: 1600), () {
      if (Get.currentRoute == AppRoutes.splash) {
        Get.offAllNamed(AppRoutes.onboarding);
      }
    });
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColor.softLavender, AppColor.background],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImagePath.splashIcon,
                width: 156,
                height: 156,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 22),
              Image.asset(ImagePath.wordmark, width: 190, fit: BoxFit.contain),
              const SizedBox(height: 14),
              const Text(
                'Authentic skincare that cares',
                style: TextStyle(color: AppColor.muted, fontSize: 14),
              ),
              const SizedBox(height: 56),
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColor.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
