import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class SystemUIHelper {
  /// Configure system UI for proper handling of Android navigation buttons
  static Future<void> configureSystemUI() async {
    if (Platform.isAndroid) {
      // Set system UI overlay style for Android
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      );
      
      // Keep navigation buttons always visible and let SafeArea handle content positioning
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom], // Keep both status bar and nav buttons visible
      );
    } else if (Platform.isIOS) {
      // iOS specific configuration
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),
      );
    }
  }
  
  /// Check if device has navigation buttons (gesture navigation vs button navigation)
  static bool hasNavigationButtons(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final viewInsets = MediaQuery.of(context).viewInsets;
    
    // On Android, if there's bottom padding beyond view insets, 
    // it usually means there are navigation buttons
    return Platform.isAndroid && (padding.bottom > viewInsets.bottom);
  }
  
  /// Get safe area padding for bottom to account for navigation buttons
  static double getBottomSafeAreaPadding(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return padding.bottom;
  }
  
  /// Configure system UI for immersive mode (hide navigation buttons temporarily)
  static Future<void> setImmersiveMode() async {
    if (Platform.isAndroid) {
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
      );
    }
  }
  
  /// Restore normal UI mode (show navigation buttons)
  static Future<void> restoreNormalMode() async {
    await configureSystemUI();
  }
} 