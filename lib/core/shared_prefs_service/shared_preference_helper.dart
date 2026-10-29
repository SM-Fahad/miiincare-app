import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _accessTokenKey = 'miiincare.access_token';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _userIdKey = 'userId';
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';

  // Onboarding state
  static Future<void> setOnboardingSeen(bool seen) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_hasSeenOnboardingKey, seen);
    } catch (_) {}
  }

  static Future<bool> isOnboardingSeen() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_hasSeenOnboardingKey) ?? false;
    } catch (_) {
      return false;
    }
  }

  // Save access token
  static Future<void> saveAccessToken(String token) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accessTokenKey, token);
    } catch (_) {}
  }

  // Get access token
  static Future<String?> getAccessToken() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_accessTokenKey);
    } catch (_) {
      return null;
    }
  }

  // Save refresh token
  static Future<void> saveRefreshToken(String token) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_refreshTokenKey, token);
    } catch (_) {}
  }

  // Get refresh token
  static Future<String?> getRefreshToken() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_refreshTokenKey);
    } catch (_) {
      return null;
    }
  }

  // Save user id
  static Future<void> saveUserId(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userIdKey, id);
    } catch (_) {}
  }

  // Get user id
  static Future<String?> getUserId() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userIdKey);
    } catch (_) {
      return null;
    }
  }

  // Clear all auth data
  static Future<void> clearAll() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);
      await prefs.remove(_userIdKey);
    } catch (_) {}
  }
}
