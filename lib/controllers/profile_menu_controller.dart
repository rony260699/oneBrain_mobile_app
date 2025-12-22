import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common_widgets/profile_dropdown_menu.dart';

/// GetX Controller for managing profile dropdown menu overlay
///
/// Usage:
/// ```dart
/// // Show the profile menu
/// Get.find<ProfileMenuController>().showProfileMenu(context);
///
/// // Hide the profile menu
/// Get.find<ProfileMenuController>().hideProfileMenu();
///
/// // Check if menu is visible
/// bool isVisible = Get.find<ProfileMenuController>().isVisible;
/// ```
class ProfileMenuController extends GetxController {
  // Observable state for menu visibility
  final RxBool _isVisible = false.obs;

  // Overlay entry reference
  OverlayEntry? _overlayEntry;

  // Getter for visibility state
  bool get isVisible => _isVisible.value;

  /// Shows the profile dropdown menu overlay
  ///
  /// [context] - BuildContext required for overlay insertion
  void showProfileMenu(BuildContext context) {
    // If already visible, do nothing
    if (_isVisible.value) {
      return;
    }

    _overlayEntry = OverlayEntry(
      builder:
          (overlayContext) => Stack(
            children: [
              // Background overlay - dismisses menu on tap
              GestureDetector(
                onTap: hideProfileMenu,
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              // Dropdown menu
              Positioned(
                top: MediaQuery.of(context).padding.top + 60,
                right: 16,
                left: 16,
                child: ProfileDropdownMenu(
                  onDismiss: hideProfileMenu,
                  mainContext: context,
                ),
              ),
            ],
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isVisible.value = true;
  }

  /// Hides the profile dropdown menu overlay
  void hideProfileMenu() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isVisible.value = false;
    }
  }

  /// Toggle the profile menu visibility
  ///
  /// [context] - BuildContext required for showing the menu
  void toggleProfileMenu(BuildContext context) {
    if (_isVisible.value) {
      hideProfileMenu();
    } else {
      showProfileMenu(context);
    }
  }

  @override
  void onClose() {
    // Clean up overlay when controller is disposed
    hideProfileMenu();
    super.onClose();
  }
}
