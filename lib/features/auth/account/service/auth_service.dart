import 'package:miiincare/core/api_end_point/api_end_point.dart';
import 'package:miiincare/core/network_service/live_api_client.dart';
import 'package:miiincare/features/auth/account/model/account_order_model.dart';
import 'package:miiincare/features/auth/account/model/auth_user_model.dart';

class AuthService {
  AuthService({LiveApiClient? client}) : _client = client ?? LiveApiClient();
  final LiveApiClient _client;

  Future<AuthSessionModel> login(String email, String password) async {
    final session = _session(
      await _client.post(ApiEndPoint.login, {
        'email': email,
        'password': password,
      }),
    );
    if (session.token.isEmpty) {
      throw Exception('Login response did not include an access token');
    }
    await LiveApiClient.saveAuthToken(session.token);
    return session;
  }

  Future<AuthSessionModel> register(
    String name,
    String email,
    String password,
  ) async {
    final session = _session(
      await _client.post(ApiEndPoint.register, {
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    if (session.token.isEmpty) {
      throw Exception('Registration response did not include an access token');
    }
    await LiveApiClient.saveAuthToken(session.token);
    return session;
  }

  Future<AuthUserModel> getProfile() async {
    final raw = await _client.get(ApiEndPoint.profile);
    if (raw is! Map) {
      throw Exception('Invalid profile response');
    }
    final data = raw['data'] is Map
        ? Map<String, dynamic>.from(raw['data'])
        : Map<String, dynamic>.from(raw);
    final user = data['user'] is Map
        ? Map<String, dynamic>.from(data['user'])
        : data;
    return AuthUserModel.fromJson(user);
  }

  Future<List<AccountOrderModel>> getOrders() async {
    final raw = await _client.get(ApiEndPoint.orders);
    if (raw is! Map) return [];
    final data = raw['data'] ?? raw;
    final items = data is List
        ? data
        : data is Map && data['items'] is List
        ? data['items'] as List
        : const [];
    return items
        .whereType<Map>()
        .map(
          (order) =>
              AccountOrderModel.fromJson(Map<String, dynamic>.from(order)),
        )
        .toList();
  }

  Future<void> logout() => LiveApiClient.clearAuthToken();

  AuthSessionModel _session(dynamic raw) {
    if (raw is! Map) throw Exception('Invalid authentication response');
    return AuthSessionModel.fromJson(Map<String, dynamic>.from(raw));
  }
}
