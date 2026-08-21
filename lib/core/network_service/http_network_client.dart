// import 'dart:convert';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:http/http.dart' as http;
// import 'package:logger/logger.dart';
// import 'package:miiincare/core/api_end_point/api_end_point.dart';
// import 'package:miiincare/core/shared_prefs_service/shared_preference_helper.dart';
// part 'http_network_response.dart';

// class HttpNetworkClient {
//   static final http.Client _client = http.Client();
//   final String _defaultErrorMsg = 'Something went wrong';
//   final Logger _logger = Logger();
//   Future<bool>? _refreshTokenFuture;

//   HttpNetworkClient();

//   String _parseErrorMessage(dynamic message) {
//     if (message == null) return _defaultErrorMsg;
//     if (message is List) {
//       return message.join(', ');
//     }
//     return message.toString();
//   }

//   Future<bool> _refreshTokenWithLock() async {
//     if (_refreshTokenFuture != null) {
//       return await _refreshTokenFuture!;
//     }
//     _refreshTokenFuture = _refreshAccessToken();
//     try {
//       final result = await _refreshTokenFuture!;
//       return result;
//     } finally {
//       _refreshTokenFuture = null;
//     }
//   }

//   Future<bool> _refreshAccessToken() async {
//     try {
//       final refreshToken = await SharedPreferencesHelper.getRefreshToken();
//       if (refreshToken == null || refreshToken.isEmpty) {
//         _logger.w('Refresh token is missing or empty');
//         await SharedPreferencesHelper.clearAll();
//         return false;
//       }
      
//       final url = ApiEndPoint.refreshToken;
//       _logger.i('Attempting to refresh access token at $url');
//       final response = await _client.post(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'refreshToken': refreshToken}),
//       ).timeout(const Duration(seconds: 10));

//       _logger.i('Refresh token response status: ${response.statusCode}, body: ${response.body}');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final body = jsonDecode(response.body);
//         String? newAccessToken;
//         String? newRefreshToken;

//         if (body is Map<String, dynamic>) {
//           final data = body['data'];
//           if (data is Map<String, dynamic>) {
//             newAccessToken = data['accessToken']?.toString() ?? data['tokens']?['accessToken']?.toString();
//             newRefreshToken = data['refreshToken']?.toString() ?? data['tokens']?['refreshToken']?.toString();
//           }
//           newAccessToken ??= body['accessToken']?.toString() ?? body['tokens']?['accessToken']?.toString();
//           newRefreshToken ??= body['refreshToken']?.toString() ?? body['tokens']?['refreshToken']?.toString();
//         }

//         if (newAccessToken != null && newAccessToken.isNotEmpty) {
//           await SharedPreferencesHelper.saveAccessToken(newAccessToken);
//           if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
//             await SharedPreferencesHelper.saveRefreshToken(newRefreshToken);
//           }
//           _logger.i('Access token refreshed successfully');
//           return true;
//         } else {
//           _logger.e('Access token not found in refresh response payload');
//         }
//       }
//     } catch (e) {
//       _logger.e('Error refreshing token: $e');
//     }

//     _logger.w('Token refresh failed. Clearing saved tokens.');
//     await SharedPreferencesHelper.clearAll();
//     return false;
//   }

//   HttpNetworkResponse _handleResponse(http.Response response) {
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       final responseBody = jsonDecode(response.body);
//       return HttpNetworkResponse(
//         statusCode: response.statusCode,
//         isSuccess: true,
//         responseData: responseBody,
//       );
//     } else if (response.statusCode == 401 || response.statusCode == 403) {
//       String errorMsg = 'Un Authorize';
//       try {
//         final responseBody = jsonDecode(response.body);
//         if (responseBody != null && responseBody['message'] != null) {
//           errorMsg = _parseErrorMessage(responseBody['message']);
//         }
//       } catch (_) {}
//       return HttpNetworkResponse(
//         statusCode: response.statusCode,
//         isSuccess: false,
//         errorMessage: errorMsg,
//       );
//     } else if (response.statusCode >= 500) {
//       EasyLoading.dismiss();
//       EasyLoading.showError('Server error (${response.statusCode}). Please try again.');
//       return HttpNetworkResponse(
//         statusCode: response.statusCode,
//         isSuccess: false,
//         errorMessage: 'Server error (${response.statusCode})',
//       );
//     } else {
//       String errorMsg = _defaultErrorMsg;
//       try {
//         final responseBody = jsonDecode(response.body);
//         errorMsg = _parseErrorMessage(responseBody['message']);
//       } catch (_) {}
//       return HttpNetworkResponse(
//         statusCode: response.statusCode,
//         isSuccess: false,
//         errorMessage: errorMsg,
//       );
//     }
//   }

//   HttpNetworkResponse _handleException(dynamic e) {
//     EasyLoading.dismiss();
//     EasyLoading.showError('Server connection error. Please try again.');
//     return HttpNetworkResponse(
//       statusCode: -1,
//       isSuccess: false,
//       errorMessage: e.toString(),
//     );
//   }

//   // GET request
//   Future<HttpNetworkResponse> getRequest({required String url}) async {
//     final token = await SharedPreferencesHelper.getAccessToken() ?? '';
//     Map<String, String> commonHeaders = {
//       'Content-Type': 'application/json',
//       'authorization': "Bearer $token",
//     };
//     try {
//       Uri uri = Uri.parse(url);
//       _logRequest(url: url, headers: commonHeaders);
//       http.Response response = await _client.get(
//         uri,
//         headers: commonHeaders,
//       ).timeout(const Duration(seconds: 10));
//       _logResponse(response: response);

//       if (response.statusCode == 401) {
//         final success = await _refreshTokenWithLock();
//         if (success) {
//           final newToken = await SharedPreferencesHelper.getAccessToken() ?? '';
//           commonHeaders['authorization'] = "Bearer $newToken";
//           _logRequest(url: url, headers: commonHeaders, isRetry: true);
//           response = await _client.get(
//             uri,
//             headers: commonHeaders,
//           ).timeout(const Duration(seconds: 10));
//           _logResponse(response: response);
//         }
//       }

//       return _handleResponse(response);
//     } on Exception catch (e) {
//       return _handleException(e);
//     }
//   }

//   // POST request
//   Future<HttpNetworkResponse> postRequest({
//     required String url,
//     required Map<String, dynamic>? body,
//     Map<String, String>? extraHeaders,
//   }) async {
//     final token = await SharedPreferencesHelper.getAccessToken() ?? '';
//     Map<String, String> commonHeaders = {
//       'content-type': 'application/json',
//       'authorization': "Bearer $token",
//     };

//     final headers = <String, String>{};
//     headers.addAll(commonHeaders);
//     if (extraHeaders != null) headers.addAll(extraHeaders);

//     try {
//       Uri uri = Uri.parse(url);
//       _logRequest(url: url, headers: headers, body: body);
//       http.Response response = await _client.post(
//         uri,
//         headers: headers,
//         body: jsonEncode(body),
//       ).timeout(const Duration(seconds: 10));
//       _logResponse(response: response);

//       if (response.statusCode == 401) {
//         final success = await _refreshTokenWithLock();
//         if (success) {
//           final newToken = await SharedPreferencesHelper.getAccessToken() ?? '';
//           headers['authorization'] = "Bearer $newToken";
//           _logRequest(url: url, headers: headers, body: body, isRetry: true);
//           response = await _client.post(
//             uri,
//             headers: headers,
//             body: jsonEncode(body),
//           ).timeout(const Duration(seconds: 10));
//           _logResponse(response: response);
//         }
//       }

//       return _handleResponse(response);
//     } on Exception catch (e) {
//       return _handleException(e);
//     }
//   }

//   // PUT request
//   Future<HttpNetworkResponse> putRequest({
//     required String url,
//     required Map<String, dynamic>? body,
//   }) async {
//     final token = await SharedPreferencesHelper.getAccessToken() ?? '';
//     Map<String, String> commonHeaders = {
//       'content-type': 'application/json',
//       'authorization': "Bearer $token",
//     };
//     try {
//       Uri uri = Uri.parse(url);
//       _logRequest(url: url, headers: commonHeaders, body: body);
//       http.Response response = await _client.put(
//         uri,
//         headers: commonHeaders,
//         body: jsonEncode(body),
//       ).timeout(const Duration(seconds: 10));
//       _logResponse(response: response);

//       if (response.statusCode == 401) {
//         final success = await _refreshTokenWithLock();
//         if (success) {
//           final newToken = await SharedPreferencesHelper.getAccessToken() ?? '';
//           commonHeaders['authorization'] = "Bearer $newToken";
//           _logRequest(url: url, headers: commonHeaders, body: body, isRetry: true);
//           response = await _client.put(
//             uri,
//             headers: commonHeaders,
//             body: jsonEncode(body),
//           ).timeout(const Duration(seconds: 10));
//           _logResponse(response: response);
//         }
//       }

//       return _handleResponse(response);
//     } on Exception catch (e) {
//       return _handleException(e);
//     }
//   }

//   // PATCH request
//   Future<HttpNetworkResponse> patchRequest({
//     required String url,
//     required Map<String, dynamic>? body,
//   }) async {
//     final token = await SharedPreferencesHelper.getAccessToken() ?? '';
//     Map<String, String> commonHeaders = {
//       'content-type': 'application/json',
//       'authorization': "Bearer $token",
//     };
//     try {
//       Uri uri = Uri.parse(url);
//       _logRequest(url: url, headers: commonHeaders, body: body);
//       http.Response response = await _client.patch(
//         uri,
//         headers: commonHeaders,
//         body: jsonEncode(body),
//       ).timeout(const Duration(seconds: 10));
//       _logResponse(response: response);

//       if (response.statusCode == 401) {
//         final success = await _refreshTokenWithLock();
//         if (success) {
//           final newToken = await SharedPreferencesHelper.getAccessToken() ?? '';
//           commonHeaders['authorization'] = "Bearer $newToken";
//           _logRequest(url: url, headers: commonHeaders, body: body, isRetry: true);
//           response = await _client.patch(
//             uri,
//             headers: commonHeaders,
//             body: jsonEncode(body),
//           ).timeout(const Duration(seconds: 10));
//           _logResponse(response: response);
//         }
//       }

//       return _handleResponse(response);
//     } on Exception catch (e) {
//       return _handleException(e);
//     }
//   }

//   // DELETE request (named param for consistency)
//   Future<HttpNetworkResponse> deleteRequest({required String url}) async {
//     final token = await SharedPreferencesHelper.getAccessToken() ?? '';
//     Map<String, String> commonHeaders = {
//       'content-type': 'application/json',
//       'authorization': "Bearer $token",
//     };
//     try {
//       Uri uri = Uri.parse(url);
//       _logRequest(url: url, headers: commonHeaders);
//       http.Response response = await _client.delete(
//         uri,
//         headers: commonHeaders,
//       ).timeout(const Duration(seconds: 10));
//       _logResponse(response: response);

//       if (response.statusCode == 401) {
//         final success = await _refreshTokenWithLock();
//         if (success) {
//           final newToken = await SharedPreferencesHelper.getAccessToken() ?? '';
//           commonHeaders['authorization'] = "Bearer $newToken";
//           _logRequest(url: url, headers: commonHeaders, isRetry: true);
//           response = await _client.delete(
//             uri,
//             headers: commonHeaders,
//           ).timeout(const Duration(seconds: 10));
//           _logResponse(response: response);
//         }
//       }

//       return _handleResponse(response);
//     } on Exception catch (e) {
//       return _handleException(e);
//     }
//   }

//   // Multipart upload request
//   Future<HttpNetworkResponse> uploadRequest({
//     required String url,
//     required List<String> filePaths,
//     String fieldName = 'images',
//   }) async {
//     final token = await SharedPreferencesHelper.getAccessToken() ?? '';
//     Map<String, String> commonHeaders = {
//       'authorization': "Bearer $token",
//     };
//     try {
//       Uri uri = Uri.parse(url);
//       _logRequest(url: url, headers: commonHeaders, body: {'filePaths': filePaths});
      
//       final request = http.MultipartRequest('POST', uri);
//       request.headers.addAll(commonHeaders);

//       for (String path in filePaths) {
//         final file = await http.MultipartFile.fromPath(fieldName, path);
//         request.files.add(file);
//       }

//       final streamedResponse = await _client.send(request).timeout(const Duration(seconds: 30));
//       final response = await http.Response.fromStream(streamedResponse);
//       _logResponse(response: response);

//       if (response.statusCode == 401) {
//         final success = await _refreshTokenWithLock();
//         if (success) {
//           final newToken = await SharedPreferencesHelper.getAccessToken() ?? '';
//           commonHeaders['authorization'] = "Bearer $newToken";
//           _logRequest(url: url, headers: commonHeaders, body: {'filePaths': filePaths}, isRetry: true);
          
//           final retryRequest = http.MultipartRequest('POST', uri);
//           retryRequest.headers.addAll(commonHeaders);
//           for (String path in filePaths) {
//             final file = await http.MultipartFile.fromPath(fieldName, path);
//             retryRequest.files.add(file);
//           }
//           final retryStreamed = await _client.send(retryRequest).timeout(const Duration(seconds: 30));
//           final retryResponse = await http.Response.fromStream(retryStreamed);
//           _logResponse(response: retryResponse);
          
//           return _handleResponse(retryResponse);
//         }
//       }

//       return _handleResponse(response);
//     } on Exception catch (e) {
//       return _handleException(e);
//     }
//   }

//   void _logRequest({
//     required String url,
//     Map<String, String>? headers,
//     Map<String, dynamic>? body,
//     bool isRetry = false,
//   }) {
//     final String message =
//         '''
//     URL -> $url
//     HEADERS -> $headers
//     BODY -> $body
//     IS_RETRY -> $isRetry
//     ''';
//     _logger.i(message);
//   }

//   void _logResponse({required http.Response response}) {
//     final String message =
//         '''
//     URL -> ${response.request?.url}
//     HEADERS -> ${response.request?.headers}
//     BODY -> ${response.body}
//     ''';
//     _logger.i(message);
//   }
// }
