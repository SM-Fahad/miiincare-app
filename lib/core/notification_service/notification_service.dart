// import 'dart:io';

// import 'package:amaking/core/api_end_point/api_end_point.dart';
// import 'package:amaking/core/network_service/http_network_client.dart';
// import 'package:amaking/core/shared_prefs_service/shared_preference_helper.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';

// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   debugPrint('FCM background message id: ${message.messageId}');
//   debugPrint('FCM background payload: ${message.data}');
// }

// class NotificationService extends GetxService {
//   static NotificationService get instance => Get.find<NotificationService>();

//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications =
//       FlutterLocalNotificationsPlugin();
//   final HttpNetworkClient _networkClient = HttpNetworkClient();

//   static const AndroidNotificationChannel _androidChannel =
//       AndroidNotificationChannel(
//         'high_importance_channel',
//         'High Importance Notifications',
//         description: 'This channel is used for important notifications.',
//         importance: Importance.max,
//       );

//   String? _fcmToken;
//   String? get fcmToken => _fcmToken;

//   Future<NotificationService> init() async {
//     await _initLocalNotifications();
//     await _initFcmListeners();

//     final accessToken = await SharedPreferencesHelper.getAccessToken();
//     if (accessToken != null && accessToken.isNotEmpty) {
//       await requestPermissionAndSyncToken();
//     }

//     return this;
//   }

//   Future<void> requestPermissionAndSyncToken() async {
//     await _requestPermissions();
//     await getFcmToken();
//     await sendDeviceTokenToBackend();
//   }

//   Future<void> _requestPermissions() async {
//     try {
//       final settings = await _messaging.requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true,
//       );

//       debugPrint('FCM permission status: ${settings.authorizationStatus.name}');

//       await _messaging.setForegroundNotificationPresentationOptions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//     } catch (e) {
//       EasyLoading.showError('Notification permission failed');
//       debugPrint('FCM permission error: $e');
//     }
//   }

//   Future<void> _initLocalNotifications() async {
//     try {
//       const androidSettings = AndroidInitializationSettings(
//         '@mipmap/launcher_icon',
//       );
//       const iosSettings = DarwinInitializationSettings(
//         requestAlertPermission: false,
//         requestBadgePermission: false,
//         requestSoundPermission: false,
//       );

//       const settings = InitializationSettings(
//         android: androidSettings,
//         iOS: iosSettings,
//       );

//       await _localNotifications.initialize(
//         settings,
//         onDidReceiveNotificationResponse: (details) {
//           debugPrint('Local notification tapped: ${details.payload}');
//         },
//       );

//       final androidPlugin = _localNotifications
//           .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin
//           >();
//       await androidPlugin?.createNotificationChannel(_androidChannel);
//     } catch (e) {
//       EasyLoading.showError('Notification setup failed');
//       debugPrint('Local notification init error: $e');
//     }
//   }

//   Future<void> _initFcmListeners() async {
//     FirebaseMessaging.onMessage.listen((message) {
//       debugPrint('FCM foreground message id: ${message.messageId}');
//       debugPrint('FCM foreground payload: ${message.data}');
//       _showLocalNotification(message);
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       debugPrint('FCM opened from background: ${message.data}');
//       _handleNotificationTap(message);
//     });

//     final initialMessage = await _messaging.getInitialMessage();
//     if (initialMessage != null) {
//       debugPrint('FCM opened from terminated: ${initialMessage.data}');
//       _handleNotificationTap(initialMessage);
//     }

//     _messaging.onTokenRefresh.listen((token) async {
//       _fcmToken = token;
//       debugPrint('FCM token refreshed: $token');
//       await sendDeviceTokenToBackend(deviceToken: token);
//     });
//   }

//   Future<String?> getFcmToken() async {
//     try {
//       _fcmToken = await _messaging.getToken();
//       debugPrint('FCM token generated: $_fcmToken');
//       return _fcmToken;
//     } catch (e) {
//       EasyLoading.showError('FCM token generation failed');
//       debugPrint('FCM token error: $e');
//       return null;
//     }
//   }

//   Future<void> sendDeviceTokenToBackend({String? deviceToken}) async {
//     try {
//       final token = deviceToken ?? _fcmToken ?? await getFcmToken();
//       if (token == null || token.isEmpty) {
//         EasyLoading.showError('FCM token is empty');
//         debugPrint('FCM device token upload skipped: empty token');
//         return;
//       }

//       final accessToken = await SharedPreferencesHelper.getAccessToken();
//       if (accessToken == null || accessToken.isEmpty) {
//         debugPrint('FCM device token upload skipped: user not logged in');
//         return;
//       }

//       final body = {
//         'deviceToken': token,
//         'platform': Platform.isIOS ? 'ios' : 'android',
//         'preferredLanguage': Get.locale?.languageCode ?? 'en',
//       };

//       final response = await _networkClient.postRequest(
//         url: ApiEndPoint.registerDevice,
//         body: body,
//       );

//       debugPrint('FCM device token API status: ${response.statusCode}');
//       debugPrint('FCM device token API success: ${response.isSuccess}');
//       debugPrint('FCM device token API response: ${response.responseData}');
//       debugPrint('FCM device token API error: ${response.errorMessage}');

//       if (!response.isSuccess) {
//         EasyLoading.showError(
//           response.errorMessage ?? 'Device token upload failed',
//         );
//       }
//     } catch (e) {
//       EasyLoading.showError('Device token upload failed');
//       debugPrint('FCM device token API exception: $e');
//     }
//   }

//   Future<void> deleteTokenOnLogout() async {
//     try {
//       await _messaging.deleteToken();
//       _fcmToken = null;
//       debugPrint('FCM token deleted on logout');
//     } catch (e) {
//       EasyLoading.showError('FCM token cleanup failed');
//       debugPrint('FCM delete token error: $e');
//     }
//   }

//   void _showLocalNotification(RemoteMessage message) {
//     final notification = message.notification;
//     final title = notification?.title ?? message.data['title']?.toString();
//     final body =
//         notification?.body ??
//         message.data['body']?.toString() ??
//         message.data['message']?.toString();

//     if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
//       return;
//     }

//     _localNotifications.show(
//       message.hashCode,
//       title,
//       body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           _androidChannel.id,
//           _androidChannel.name,
//           channelDescription: _androidChannel.description,
//           importance: Importance.max,
//           priority: Priority.high,
//           icon: '@mipmap/launcher_icon',
//         ),
//         iOS: const DarwinNotificationDetails(
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ),
//       ),
//       payload: message.data.toString(),
//     );
//   }

//   void _handleNotificationTap(RemoteMessage message) {
//     final notificationId = message.data['notificationId']?.toString();
//     debugPrint('Notification tapped. notificationId: $notificationId');
//   }
// }
