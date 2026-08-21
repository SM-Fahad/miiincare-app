import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LiveApiClient {
  LiveApiClient({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;
  static String? _cookie;
  static String? _token;
  static bool _sessionLoaded = false;
  static const _cookieKey = 'miiincare.guest_cookie';
  static const _tokenKey = 'miiincare.access_token';

  Map<String, String> get _headers {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
    final cookie = _cookie;
    if (cookie != null) {
      headers['Cookie'] = cookie;
    }
    return headers;
  }

  Future<dynamic> get(String url) => _request('GET', url);

  Future<dynamic> post(String url, Map<String, dynamic> body) =>
      _request('POST', url, body: body);

  Future<dynamic> patch(String url, Map<String, dynamic> body) =>
      _request('PATCH', url, body: body);

  Future<dynamic> delete(String url) => _request('DELETE', url);

  Future<dynamic> _request(
    String method,
    String url, {
    Map<String, dynamic>? body,
  }) async {
    await _loadSession();
    final request = http.Request(method, Uri.parse(url));
    request.headers.addAll(_headers);
    if (body != null) request.body = jsonEncode(body);
    final streamed = await _client
        .send(request)
        .timeout(const Duration(seconds: 15));
    final response = await http.Response.fromStream(streamed);
    final setCookie = response.headers['set-cookie'];
    if (setCookie != null && setCookie.isNotEmpty) {
      _cookie = setCookie.split(';').first;
      await _persistValue(_cookieKey, _cookie!);
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      String message = 'Request failed (${response.statusCode})';
      try {
        final error = jsonDecode(response.body);
        if (error is Map && error['message'] != null) {
          message = '${error['message']}';
        }
      } catch (_) {}
      throw Exception(message);
    }
    return jsonDecode(response.body);
  }

  static Future<void> saveAuthToken(String token) async {
    _token = token;
    await _persistValue(_tokenKey, token);
  }

  static Future<void> clearAuthToken() async {
    _token = null;
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.remove(_tokenKey);
    } catch (_) {
      // Persistence is optional; network requests must keep working when a
      // newly added native plugin has not been registered until full restart.
    }
  }

  static Future<void> _loadSession() async {
    if (_sessionLoaded) return;
    try {
      final preferences = await SharedPreferences.getInstance();
      _cookie = preferences.getString(_cookieKey);
      _token = preferences.getString(_tokenKey);
    } catch (_) {
      // Fall back to an in-memory session rather than blocking every API call.
    } finally {
      _sessionLoaded = true;
    }
  }

  static Future<void> _persistValue(String key, String value) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(key, value);
    } catch (_) {
      // The current session still works in memory when persistence is absent.
    }
  }
}
