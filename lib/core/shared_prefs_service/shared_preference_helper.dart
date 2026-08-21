// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPreferencesHelper {
//   static const String _accessTokenKey = 'accessToken';
//   static const String _refreshTokenKey = 'refreshToken';

//   // Save access token
//   static Future<void> saveAccessToken(String token) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_accessTokenKey, token);
//   }

//   // Get access token
//   static Future<String?> getAccessToken() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_accessTokenKey);
//   }

//   // Save refresh token
//   static Future<void> saveRefreshToken(String token) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_refreshTokenKey, token);
//   }

//   // Get refresh token
//   static Future<String?> getRefreshToken() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_refreshTokenKey);
//   }

//   static const String _userIdKey = 'userId';

//   // Save user id
//   static Future<void> saveUserId(String id) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_userIdKey, id);
//   }

//   // Get user id
//   static Future<String?> getUserId() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_userIdKey);
//   }

//   // Clear all auth data
//   static Future<void> clearAll() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_accessTokenKey);
//     await prefs.remove(_refreshTokenKey);
//     await prefs.remove(_userIdKey);
//   }
// }