import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

class NotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool isInitialized = false;

  static Future<void> init() async {
    bool permissionGranted = await requestNotificationPermission();
    if (!permissionGranted) return;

    if (isInitialized) return;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await setUpLocalNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message received: ${message.data}');
      if (Platform.isAndroid) {
        createAndDisplayNotification(
          message: message,
          flutterLocalNotificationsPlugin: _notificationsPlugin,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      NotificationTapHandler.notificationTap(message.data);
    });

    // FCM token safe call
    await getFCMToken();

    isInitialized = true;
  }

  static Future<void> setUpLocalNotification() async {
    /// initializationSettings for iOS
    DarwinInitializationSettings initializationSettingsDarwin =
        const DarwinInitializationSettings();

    /// initializationSettings for Android
    const initializationSettingsAndroid = AndroidInitializationSettings(
      'splash',
    );
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static String? token;

  static Future<String?> getFCMToken() async {
    try {
      // iOS: wait for APNS token first
      if (Platform.isIOS) {
        final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        print("APNS Token: $apnsToken");

        if (apnsToken == null) {
          print("APNS token not ready yet. FCM token will not be fetched.");
          return null; // abhi token ready nahi
        }
      }

      // FCM token
      token = await messaging.getToken();
      print("FCM Token: $token");

      // Listen for future token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        print("FCM Token Refreshed: $newToken");
        token = newToken;
      });

      return token;
    } catch (e) {
      print("Error getting FCM token: $e");
      return null;
    }
  }

  static Future<String> _downloadAndSaveFile(
    String url,
    String fileName,
  ) async {
    final directory = await Directory.systemTemp.createTemp();
    final filePath = '${directory.path}/$fileName';
    final response = await HttpClient().getUrl(Uri.parse(url));
    final file = File(filePath);
    final httpResponse = await response.close();
    await httpResponse.pipe(file.openWrite());
    return filePath;
  }

  static Future createAndDisplayNotification({
    required RemoteMessage? message,
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  }) async {
    String? imageUrl = message?.notification?.android?.imageUrl;

    AndroidNotificationDetails androidNotificationDetails;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      // Big Picture Style with image
      final bigPicture = BigPictureStyleInformation(
        FilePathAndroidBitmap(await _downloadAndSaveFile(imageUrl, 'bigImage')),
        largeIcon: const DrawableResourceAndroidBitmap('splash'),
        contentTitle: message?.notification?.title,
        summaryText: message?.notification?.body,
      );

      androidNotificationDetails = AndroidNotificationDetails(
        "onebrain_app",
        "onebrain_app_channel",
        styleInformation: bigPicture,
        importance: Importance.max,
        priority: Priority.high,
      );
    } else {
      // Normal notification
      androidNotificationDetails = const AndroidNotificationDetails(
        "onebrain_app",
        "onebrain_app_channel",
        largeIcon: DrawableResourceAndroidBitmap('splash'),
        importance: Importance.max,
        priority: Priority.high,
      );
    }

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      message?.hashCode ?? 0,
      message?.notification?.title,
      message?.notification?.body,
      notificationDetails,
      payload: json.encode(message?.data),
    );
  }

  static Future<bool> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    print('User granted permission: ${settings.authorizationStatus}');

    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  if (response.payload == null) {
    return;
  }
  Map<String, dynamic> notificationResponse = json.decode(response.payload!);

  NotificationTapHandler.notificationTap(notificationResponse);
}

void onDidReceiveNotificationResponse(
  NotificationResponse notificationResponse,
) async {
  String? payload = notificationResponse.payload;
  if (payload == null) {
    return;
  }
  Map<String, dynamic> payloadMap = json.decode(payload);
  NotificationTapHandler.notificationTap(payloadMap);
}

class NotificationTapHandler {
  static notificationTap(Map<String, dynamic>? data) async {
    print("Notification data: $data");

    try {} catch (e) {
      log("error : E $e");
    }
  }
}
