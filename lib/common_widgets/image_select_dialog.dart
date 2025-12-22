import 'dart:io';
import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

class ImageSelectDialog {
  static final ImagePicker _picker = ImagePicker();
  static bool isProgress = false;

  /// Modern attachment selection dialog with Files, Camera, and Photos options
  static Future<dynamic> onImageSelection2({
    int? imageCount,
    required BuildContext mainContext,
    List<CropAspectRatioPreset>? aspectRatioCrop,
  }) async {
    final Completer<dynamic> completer = Completer<dynamic>();
    bool operationInProgress = false;

    if (kDebugMode) {
      print("🎯 onImageSelection2 called with imageCount: $imageCount");
      print("🎯 Context mounted: ${mainContext.mounted}");
    }

    showModalBottomSheet<dynamic>(
      context: mainContext,
      enableDrag: true,
      useSafeArea: true,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            if (!completer.isCompleted) {
              completer.complete(null);
            }
            return true;
          },
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF2A2A2A),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Title
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Select Attachment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // All options in horizontal card layout
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // First row: Attachment options
                        Row(
                          children: [
                            // Camera option
                            Expanded(
                              child: _buildHorizontalOptionTile(
                                context: context,
                                icon: Icons.camera_alt,
                                title: 'Camera',
                                onTap: () async {
                                  if (operationInProgress) {
                                    return;
                                  }
                                  operationInProgress = true;
                                  try {
                                    await _handleCameraWithCompleter(
                                      context,
                                      imageCount,
                                      aspectRatioCrop,
                                      completer,
                                    );
                                  } catch (e) {
                                    if (!completer.isCompleted) {
                                      completer.complete(null);
                                    }
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 12),
                            // Photos option
                            Expanded(
                              child: _buildHorizontalOptionTile(
                                context: context,
                                icon: Icons.photo_library,
                                title: 'Photos',
                                onTap: () async {
                                  if (kDebugMode) {
                                    print("📱 Photos option tapped!");
                                  }
                                  if (operationInProgress) {
                                    if (kDebugMode) {
                                      print(
                                        "📱 Operation already in progress, ignoring tap",
                                      );
                                    }
                                    return;
                                  }
                                  operationInProgress = true;

                                  try {
                                    await _handlePhotosWithCompleter(
                                      context,
                                      imageCount,
                                      aspectRatioCrop,
                                      completer,
                                    );
                                  } catch (e) {
                                    if (kDebugMode) {
                                      print("📱 Photos handler error: $e");
                                    }
                                    if (!completer.isCompleted) {
                                      completer.complete(null);
                                    }
                                  }
                                },
                              ),
                            ),

                            SizedBox(width: 12),

                            // Files option
                            Expanded(
                              child: _buildHorizontalOptionTile(
                                context: context,
                                icon: Icons.insert_drive_file,
                                title: 'Files',
                                onTap: () async {
                                  if (kDebugMode) {
                                    print("📁 Files option tapped!");
                                  }
                                  if (operationInProgress) {
                                    if (kDebugMode) {
                                      print(
                                        "📁 Operation already in progress, ignoring tap",
                                      );
                                    }
                                    return;
                                  }
                                  operationInProgress = true;

                                  try {
                                    await _handleFilesWithCompleter(
                                      context,
                                      imageCount,
                                      aspectRatioCrop,
                                      completer,
                                    );
                                  } catch (e) {
                                    if (kDebugMode) {
                                      print("📁 Files handler error: $e");
                                    }
                                    if (!completer.isCompleted) {
                                      completer.complete(null);
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        // Additional options as individual tiles
                        // _buildFullWidthOptionTile(
                        //   context: context,
                        //   icon: Icons.language,
                        //   title: 'Search the web',
                        //   onTap: () {
                        //     Navigator.pop(context);
                        //     if (!completer.isCompleted) {
                        //       completer.complete('search_web');
                        //     }
                        //   },
                        // ),

                        // SizedBox(height: 12),

                        // _buildFullWidthOptionTile(
                        //   context: context,
                        //   icon: Icons.lightbulb_outline,
                        //   title: 'Think for longer',
                        //   subtitle: '1 min',
                        //   onTap: () {
                        //     Navigator.pop(context);
                        //     if (!completer.isCompleted) {
                        //       completer.complete('think_longer');
                        //     }
                        //   },
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );

    final result = await completer.future;
    if (kDebugMode) {
      print("🎯 onImageSelection2 completed with result: $result");
    }
    return result;
  }

  static Widget _buildModernOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFF3A3A3A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white54,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!isLast)
          Container(
            height: 1,
            margin: EdgeInsets.symmetric(horizontal: 24),
            color: Color(0xFF404040),
          ),
      ],
    );
  }

  /// Build horizontal option tile for bottom sheet
  static Widget _buildHorizontalOptionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[700]!, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build simple text option for additional features
  static Widget _buildFullWidthOptionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            SizedBox(width: 16),
            Expanded(
              child: Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    Text(
                      ' • ',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build option tile for bottom sheet (kept for compatibility)
  static Widget _buildOptionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[700]!, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[400], fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[500], size: 14),
          ],
        ),
      ),
    );
  }

  /// Handle file picker for any file type
  static Future<void> _handleFilePicker(BuildContext context) async {
    try {
      // Get the navigator before closing the bottom sheet
      final navigator = Navigator.of(context, rootNavigator: true);

      // Close the bottom sheet first
      Navigator.pop(context);

      // Add a longer delay to ensure the bottom sheet is fully closed and animations complete
      await Future.delayed(Duration(milliseconds: 300));

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
        allowCompression: false,
      );

      if (result != null && result.files.isNotEmpty) {
        // Convert PlatformFile to file paths
        List<String> filePaths =
            result.files
                .where((file) => file.path != null)
                .map((file) => file.path!)
                .toList();

        if (filePaths.isNotEmpty) {
          print('File picker returning: $filePaths');
          // Use the navigator we captured earlier
          navigator.pop(filePaths);
        }
      }
    } catch (e) {
      print('File picker error: $e');
      // Ensure we close any remaining modals
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  /// Handle camera with completer pattern
  static Future<void> _handleCameraWithCompleter(
    BuildContext context,
    int? imageCount,
    List<CropAspectRatioPreset>? aspectRatioCrop,
    Completer<dynamic> completer,
  ) async {
    try {
      // Close the bottom sheet first
      Navigator.pop(context);
      // Add a delay to ensure the bottom sheet is fully closed
      await Future.delayed(Duration(milliseconds: 100));
      // Check camera permission
      PermissionStatus cameraStatus = await Permission.camera.request();
      // print("Camera permission status: ${cameraStatus.toString()}");
      // cameraStatus = await Permission.camera.request();
      // print(
      //   "Camera permission status after request: ${cameraStatus.toString()}",
      // );
      if (cameraStatus.isGranted) {
        // Permission already granted, proceed
        await _pickImageWithCompleter(
          ImageSource.camera,
          imageCount,
          completer,
        );
      } else if (cameraStatus.isDenied) {
        // Request permission
        PermissionStatus newStatus = await Permission.camera.request();
        if (newStatus.isGranted) {
          await _pickImageWithCompleter(
            ImageSource.camera,
            imageCount,
            completer,
          );
        } else if (newStatus.isPermanentlyDenied) {
          _showPermissionDialog(context, "Camera", "camera access");
          if (!completer.isCompleted) completer.complete(null);
        } else {
          if (!completer.isCompleted) completer.complete(null);
        }
      } else if (cameraStatus.isPermanentlyDenied) {
        _showPermissionDialog(context, "Camera", "camera access");
        if (!completer.isCompleted) completer.complete(null);
      }
    } catch (e) {
      if (!completer.isCompleted) completer.complete(null);
    }
  }

  /// Handle photos with completer pattern
  static Future<void> _handlePhotosWithCompleter(
    BuildContext context,
    int? imageCount,
    List<CropAspectRatioPreset>? aspectRatioCrop,
    Completer<dynamic> completer,
  ) async {
    try {
      if (kDebugMode) {
        print("📱 Photos handler with completer started");
      }
      // Close the bottom sheet first
      Navigator.pop(context);
      // Add a delay to ensure the bottom sheet is fully closed
      await Future.delayed(Duration(milliseconds: 100));
      if (Platform.isAndroid) {
        // Determine the correct permission based on Android version
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        Permission targetPermission =
            androidInfo.version.sdkInt <= 32
                ? Permission.storage
                : Permission.photos;
        PermissionStatus currentStatus = await targetPermission.status;
        if (currentStatus.isGranted) {
          // Permission already granted, proceed
          await _pickImageWithCompleter(
            ImageSource.gallery,
            imageCount,
            completer,
          );
        } else if (currentStatus.isDenied) {
          // Request permission
          PermissionStatus newStatus = await targetPermission.request();
          if (newStatus.isGranted) {
            await _pickImageWithCompleter(
              ImageSource.gallery,
              imageCount,
              completer,
            );
          } else if (newStatus.isPermanentlyDenied) {
            _showPermissionDialog(context, "Photos", "photo access");
            if (!completer.isCompleted) completer.complete(null);
          } else {
            if (!completer.isCompleted) completer.complete(null);
          }
        } else if (currentStatus.isPermanentlyDenied) {
          _showPermissionDialog(context, "Photos", "photo access");
          if (!completer.isCompleted) completer.complete(null);
        }
      } else {
        // iOS - proceed directly (iOS handles permissions automatically)
        await _pickImageWithCompleter(
          ImageSource.gallery,
          imageCount,
          completer,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('📱 Photos handler error: $e');
      }
      if (!completer.isCompleted) completer.complete(null);
    }
  }

  /// Handle files with completer pattern
  static Future<void> _handleFilesWithCompleter(
    BuildContext context,
    int? imageCount,
    List<CropAspectRatioPreset>? aspectRatioCrop,
    Completer<dynamic> completer,
  ) async {
    try {
      if (kDebugMode) {
        print("📁 Files handler with completer started");
      }

      // Close the bottom sheet first
      Navigator.pop(context);

      // Add a delay to ensure the bottom sheet is fully closed
      await Future.delayed(Duration(milliseconds: 100));

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'xls',
          'xlsx',
          'ppt',
          'pptx',
          'txt',
          'csv',
          'zip',
          'rar',
          'jpg',
          'jpeg',
          'png',
          'webp',
          'mp3',
          'wav',
        ],
      );

      if (result != null && result.files.isNotEmpty) {
        List<String> selectedFiles =
            result.paths.where((path) => path != null).cast<String>().toList();

        if (selectedFiles.isNotEmpty) {
          if (kDebugMode) {
            print("📁 Selected ${selectedFiles.length} files");
          }
          if (!completer.isCompleted) {
            completer.complete(selectedFiles);
          }
        } else {
          if (!completer.isCompleted) {
            completer.complete(null);
          }
        }
      } else {
        if (kDebugMode) {
          print("📁 No files selected");
        }
        if (!completer.isCompleted) {
          completer.complete(null);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("📁 File picker error: $e");
      }
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    }
  }

  /// Pick image with completer for better result handling
  static Future<void> _pickImageWithCompleter(
    ImageSource source,
    int? imageCount,
    Completer<dynamic> completer,
  ) async {
    try {
      if (kDebugMode) {
        print("📸 Starting camera picker...");
      }

      // Add null safety guard
      if (_picker == null) {
        if (kDebugMode) {
          print("📸 Error: ImagePicker is null");
        }
        if (!completer.isCompleted) {
          completer.complete(null);
        }
        return;
      }

      // Single image selection with better error handling
      XFile? image;
      try {
        image = await _picker.pickImage(
          source: source,
          maxWidth: 800,
          maxHeight: 800,
          imageQuality: 60,
        );
      } catch (pickerError) {
        if (kDebugMode) {
          print("📸 ImagePicker error: $pickerError");
        }
        if (!completer.isCompleted) {
          completer.complete(null);
        }
        return;
      }

      if (kDebugMode) {
        print("📸 Camera picker completed. Image: ${image?.path}");
      }

      if (image != null && image.path.isNotEmpty) {
        // Return the image path directly (skip cropping for now to avoid complexity)
        if (kDebugMode) {
          print('📸 Camera image picked: ${image.path}');
        }
        if (!completer.isCompleted) {
          completer.complete(image.path);
        }
      } else {
        if (kDebugMode) {
          print("📸 No image selected or path is empty");
        }
        if (!completer.isCompleted) {
          completer.complete(null);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('📸 Pick image with completer error: $e');
      }
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    }
  }

  /// Simplified image picker that avoids navigation context issues
  static Future<void> _pickImageSimple(
    BuildContext context,
    ImageSource source,
    int? imageCount,
    NavigatorState navigator,
  ) async {
    try {
      if (kDebugMode) {
        print("📸 Starting camera picker...");
      }

      if (source == ImageSource.gallery &&
          imageCount != null &&
          imageCount > 1) {
        // Multiple image selection from gallery
        List<XFile>? images;
        try {
          images = await _picker.pickMultiImage(
            maxWidth: 800,
            maxHeight: 800,
            imageQuality: 60,
          );
        } catch (e) {
          if (kDebugMode) {
            print("📸 Gallery picker error: $e");
          }
          return;
        }

        if (images != null && images.isNotEmpty) {
          List<String> imagePaths = images.map((xfile) => xfile.path).toList();
          if (kDebugMode) {
            print('📸 Gallery multiple returning: $imagePaths');
          }
          if (context.mounted) {
            navigator.pop(imagePaths);
          }
        }
      } else {
        // Single image selection
        XFile? image;
        try {
          image = await _picker.pickImage(
            source: source,
            maxWidth: 800,
            maxHeight: 800,
            imageQuality: 60,
          );
        } catch (e) {
          if (kDebugMode) {
            print("📸 Camera picker error: $e");
          }
          return;
        }

        if (kDebugMode) {
          print("📸 Camera picker completed. Image: ${image?.path}");
        }

        if (image != null && image.path.isNotEmpty) {
          // Check if the context is still mounted before using navigator
          if (kDebugMode) {
            print("📸 Context mounted: ${context.mounted}");
          }

          if (context.mounted) {
            // Return the image path directly (skip cropping for now to avoid complexity)
            if (kDebugMode) {
              print('📸 Camera image picked: ${image.path}');
            }
            navigator.pop(image.path);
          } else {
            if (kDebugMode) {
              print("📸 Context not mounted, cannot return result");
            }
          }
        } else {
          if (kDebugMode) {
            print("📸 No image selected or path is empty");
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('📸 Pick image simple error: $e');
      }
      // Ensure we close any remaining modals only if context is mounted
      if (context.mounted) {
        navigator.pop();
      }
    }
  }

  /// Show permission dialog
  static void _showPermissionDialog(
    BuildContext context,
    String feature,
    String permission,
  ) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Color(0xFF2A2A2A),
            title: Text(
              '$feature Permission Required',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              '$feature access is disabled. Please allow permission for $permission in your device settings.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: Colors.white70)),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await openAppSettings();
                },
                child: Text('Settings', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  /// Show error dialog
  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Color(0xFF2A2A2A),
            title: Text('Error', style: TextStyle(color: Colors.white)),
            content: Text(message, style: TextStyle(color: Colors.white70)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  // Legacy method for backward compatibility
  static Future<dynamic> onImageSelection({
    int? imageCount,
    required BuildContext mainContext,
    List<CropAspectRatioPreset>? aspectRatioCrop,
  }) async {
    return onImageSelection2(
      imageCount: imageCount,
      mainContext: mainContext,
      aspectRatioCrop: aspectRatioCrop,
    );
  }
}

typedef OnShowProgress = void Function(bool showProgress);
