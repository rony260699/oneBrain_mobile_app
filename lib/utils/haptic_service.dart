import 'package:flutter/services.dart';

class HapticService {
  // Private constructor
  HapticService._();

  // Singleton instance
  static final HapticService _instance = HapticService._();
  static HapticService get instance => _instance;

  /// Light haptic feedback when AI starts responding
  static void onResponseStart() {
    HapticFeedback.lightImpact();
  }

  /// Subtle haptic feedback during text generation (every few characters)
  static void onTextGeneration() {
    HapticFeedback.selectionClick();
  }

  /// Medium haptic feedback when AI response completes
  static void onResponseComplete() {
    HapticFeedback.mediumImpact();
  }

  /// Heavy haptic feedback for errors
  static void onError() {
    HapticFeedback.heavyImpact();
  }

  /// Light haptic feedback for user interactions (button taps, etc.)
  static void onUserInteraction() {
    HapticFeedback.lightImpact();
  }

  /// Heavy haptic feedback for important actions
  static void onImportantAction() {
    HapticFeedback.heavyImpact();
  }

  /// Selection haptic feedback for UI elements
  static void onSelection() {
    HapticFeedback.selectionClick();
  }

  /// ChatGPT-style typing pattern
  /// Call this method every 3-5 characters during text generation
  static void chatGPTTypingPattern(int characterCount) {
    // Haptic feedback every 4 characters (like ChatGPT)
    if (characterCount % 4 == 0) {
      HapticFeedback.selectionClick();
    }
  }

  /// Sequence of haptics for message send action
  static void onMessageSent() {
    HapticFeedback.lightImpact();
    // Add a small delay for double tap effect
    Future.delayed(const Duration(milliseconds: 50), () {
      HapticFeedback.selectionClick();
    });
  }

  /// Haptic pattern for new conversation start
  static void onNewConversation() {
    HapticFeedback.mediumImpact();
  }

  /// Haptic pattern for copy action
  static void onCopyAction() {
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 100), () {
      HapticFeedback.selectionClick();
    });
  }
}
