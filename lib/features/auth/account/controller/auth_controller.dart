import 'package:get/get.dart';
import 'package:miiincare/features/auth/account/model/account_order_model.dart';
import 'package:miiincare/features/auth/account/model/auth_user_model.dart';
import 'package:miiincare/features/auth/account/service/auth_service.dart';

class AuthController extends GetxController {
  AuthController({AuthService? service}) : _service = service ?? AuthService();
  final AuthService _service;
  final Rxn<AuthUserModel> user = Rxn<AuthUserModel>();
  final orders = <AccountOrderModel>[].obs;
  final isLoading = true.obs;
  final isSubmitting = false.obs;
  final error = ''.obs;
  bool get isAuthenticated => user.value != null;

  @override
  void onInit() {
    super.onInit();
    restoreSession();
  }

  Future<void> restoreSession() async {
    isLoading.value = true;
    try {
      user.value = await _service.getProfile();
      await loadOrders();
    } catch (_) {
      user.value = null;
      orders.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> login(String email, String password) async =>
      _authenticate(() => _service.login(email, password));
  Future<bool> register(String name, String email, String password) async =>
      _authenticate(() => _service.register(name, email, password));

  Future<bool> _authenticate(Future<AuthSessionModel> Function() action) async {
    isSubmitting.value = true;
    error.value = '';
    try {
      user.value = (await action()).user;
      await loadOrders();
      return true;
    } catch (e) {
      error.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> loadOrders() async {
    if (!isAuthenticated) return;
    try {
      orders.assignAll(await _service.getOrders());
    } catch (_) {
      orders.clear();
    }
  }

  Future<void> logout() async {
    await _service.logout();
    user.value = null;
    orders.clear();
  }
}
