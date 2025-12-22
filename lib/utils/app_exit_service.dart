import 'dart:io';
import 'package:flutter/services.dart';

class AppExitService {
  static const platform = MethodChannel('onebrain.app/system');

  /// Exit the app properly on Android
  static Future<void> exitApp() async {
    try {
      if (Platform.isAndroid) {
        await platform.invokeMethod('exitApp');
      } else if (Platform.isIOS) {
        // On iOS, just pop the last route to go to background
        // iOS doesn't allow programmatic app termination
        exit(0);
      }
    } on PlatformException catch (e) {
      print("Failed to exit app: '${e.message}'.");
      // Fallback to system exit
      exit(0);
    }
  }

  /// Check if we can exit the app (only on Android)
  static bool canExitApp() {
    return Platform.isAndroid;
  }
} 