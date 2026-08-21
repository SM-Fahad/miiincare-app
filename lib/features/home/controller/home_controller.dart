import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;
  final heroIndex = 0.obs;
  final heroPageController = PageController();
  Timer? _heroTimer;

  @override
  void onInit() {
    super.onInit();
    final initialTab = Get.arguments;
    if (initialTab is int && initialTab >= 0 && initialTab <= 4) {
      currentIndex.value = initialTab;
    }
    _heroTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!heroPageController.hasClients) return;
      heroPageController.animateToPage(
        (heroIndex.value + 1) % 3,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void changeTab(int index) => currentIndex.value = index;
  void changeHero(int index) => heroIndex.value = index;

  @override
  void onClose() {
    _heroTimer?.cancel();
    heroPageController.dispose();
    super.onClose();
  }
}
