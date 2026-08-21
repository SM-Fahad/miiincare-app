import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miiincare/routes/app_routes.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;
  Timer? _autoPlayTimer;

  bool get isLastPage => currentPage.value == 2;

  void onPageChanged(int index) => currentPage.value = index;

  @override
  void onInit() {
    super.onInit();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!pageController.hasClients) return;
      final nextPage = (currentPage.value + 1) % 3;
      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  Future<void> next() async {
    if (isLastPage) {
      finish();
      return;
    }
    await pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  void finish() => Get.offAllNamed(AppRoutes.home);

  @override
  void onClose() {
    _autoPlayTimer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
