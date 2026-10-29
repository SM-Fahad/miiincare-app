import 'package:get/get.dart';
import 'package:miiincare/core/shared_prefs_service/shared_preference_helper.dart';
import 'package:miiincare/routes/app_routes.dart';

class SplashController extends GetxController {
  bool isLogin = false;

  @override
  void onInit() {
    super.onInit();
    navigateToNextScreen();
  }

  Future<void> checkLoginStatus() async {
    final accessToken = await SharedPreferencesHelper.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      isLogin = true;
    }
  }

  Future<void> navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 1600));

    if (Get.currentRoute == AppRoutes.splash) {
      final hasSeenOnboarding = await SharedPreferencesHelper.isOnboardingSeen();
      await checkLoginStatus();

      if (!hasSeenOnboarding) {
        Get.offAllNamed(AppRoutes.onboarding);
      } else {
        Get.offAllNamed(AppRoutes.home);
      }
    }
  }
}
