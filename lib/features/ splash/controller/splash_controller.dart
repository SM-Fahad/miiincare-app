
import 'package:get/get.dart';

class SplashController extends GetxController {
  bool isLogin = false;  

  Future<void> checkLoginStatus() async {
    // final accessToken = await SharedPreferencesHelper.getAccessToken();
    // final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    // if (accessToken != null &&
    //     accessToken.isNotEmpty &&
    //     refreshToken != null &&
    //     refreshToken.isNotEmpty) {
    //   isLogin = true;
    // }
  }

  @override
  void onInit() {
    super.onInit();
    // navigationtoOnboarding();
  }

  // Future<void> navigationtoOnboarding() async {
  //   Future.delayed(const Duration(seconds: 3), () async {
  //     await checkLoginStatus();
  //     if (isLogin) {
  //       final profileService = ProfileService();
  //       await profileService.handleUserRouting();
  //     } else {
  //       Get.offAllNamed(AppRoutes.onboarding);
  //     }
  //   });
  // }
}
