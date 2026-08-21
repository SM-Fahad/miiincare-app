import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miiincare/core/constants/app_color.dart';
import 'package:miiincare/core/constants/image_path.dart';
import 'package:miiincare/features/onboarding/controller/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final OnboardingController controller = Get.put(OnboardingController());

  static const _pages = [
    _OnboardingData(
      image: ImagePath.hero,
      eyebrow: 'AUTHENTIC BEAUTY',
      title: 'Skincare you can trust, shopping you’ll enjoy.',
      description: 'Made with natural ingredients you can trust.',
    ),
    _OnboardingData(
      image: ImagePath.heroTwo,
      eyebrow: 'MADE FOR YOUR ROUTINE',
      title: 'Find your perfect match',
      description: 'Tested for safety and suitable for all skin.',
    ),
    _OnboardingData(
      image: ImagePath.heroThree,
      eyebrow: 'BEAUTY, DELIVERED',
      title: 'Visible results, better tomorrow',
      description:
          'High performance formulas for visible results.\nEco-conscious packaging for a better tomorrow.',
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    extendBody: true,
    body: Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: controller.pageController,
          onPageChanged: controller.onPageChanged,
          itemCount: _pages.length,
          itemBuilder: (_, index) => _OnboardingPage(data: _pages[index]),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, right: 16),
              child: TextButton(
                onPressed: controller.finish,
                child: const Text('Skip'),
              ),
            ),
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: controller.currentPage.value == index ? 26 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: controller.currentPage.value == index
                                ? AppColor.primary
                                : AppColor.border,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: controller.next,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                      ),
                      child: Text(
                        controller.isLastPage ? 'Get started' : 'Next',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});
  final _OnboardingData data;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(image: AssetImage(data.image), fit: BoxFit.cover),
    ),
    child: Container(
      padding: const EdgeInsets.fromLTRB(24, 100, 24, 190),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.35, 0.68, 1],
          colors: [Colors.transparent, Color(0x99FBFAFD), AppColor.background],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            data.eyebrow,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColor.primary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColor.ink,
              fontSize: 30,
              height: 1.12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColor.muted,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    ),
  );
}

class _OnboardingData {
  const _OnboardingData({
    required this.image,
    required this.eyebrow,
    required this.title,
    required this.description,
  });
  final String image;
  final String eyebrow;
  final String title;
  final String description;
}
