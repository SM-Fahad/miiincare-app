import 'package:get/get.dart';
import 'package:miiincare/features/best_sellers/screen/best_sellers_screen.dart';
import 'package:miiincare/features/auth/account/screen/auth_form_screen.dart';
import 'package:miiincare/features/checkout/screen/checkout_screen.dart';
import 'package:miiincare/features/checkout/screen/order_success_screen.dart';
import 'package:miiincare/features/%20splash/screen/splash_screen.dart';
import 'package:miiincare/features/home/screen/home_screen.dart';
import 'package:miiincare/features/onboarding/screen/onboarding_screen.dart';
import 'package:miiincare/features/orders/screen/order_detail_screen.dart';
import 'package:miiincare/features/product/screen/product_screen.dart';

class AppRoutes {
  static const splash = '/splash';
  static const home = '/home';
  static const onboarding = '/onboarding';
  static const product = '/product';
  static const bestSellers = '/best-sellers';
  static const checkout = '/checkout';
  static const orderSuccess = '/order-success';
  static const login = '/login';
  static const register = '/register';
  static const orderDetails = '/order/:id';

  static String orderDetailsFor(String id) => '/order/$id';

  static final routes = <GetPage>[
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: onboarding, page: () => OnboardingScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: product, page: () => const ProductScreen()),
    GetPage(name: bestSellers, page: () => BestSellersScreen()),
    GetPage(name: checkout, page: () => CheckoutScreen()),
    GetPage(name: orderSuccess, page: () => const OrderSuccessScreen()),
    GetPage(name: login, page: () => AuthFormScreen(isRegister: false)),
    GetPage(name: register, page: () => AuthFormScreen(isRegister: true)),
    GetPage(
      name: orderDetails,
      page: () => OrderDetailScreen(orderId: Get.parameters['id'] ?? ''),
    ),
  ];
}
