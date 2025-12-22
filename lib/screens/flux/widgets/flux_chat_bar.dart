import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../common_widgets/hexcolor.dart';
import '../../../common_widgets/image_select_dialog.dart';
import '../../../resources/image.dart';
import '../../../resources/strings.dart';
import '../provider/flux_provider.dart';

class FluxChatBar extends StatefulWidget {
  final ScrollController? scrollController;
  
  const FluxChatBar({Key? key, this.scrollController}) : super(key: key);
  
  @override
  _FluxChatBarState createState() => _FluxChatBarState();
}

class _FluxChatBarState extends State<FluxChatBar> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  List<XFile> _selectedImages = [];
  String _selectedModel = "flux-pro";
  String _selectedAspectRatio = "1:1";
  bool _isLoading = false;
  String? _error;
  
  // Model options for Flux
  final List<Map<String, String>> _models = [
    {"label": "Flux Pro", "value": "flux-pro"},
    {"label": "Flux Pro 1.1", "value": "flux-pro-1.1"},
  ];
  
  // Aspect ratio options
  final List<Map<String, String>> _aspectRatios = [
    {"label": "Square (1:1)", "value": "1:1"},
    {"label": "Landscape (16:9)", "value": "16:9"},
    {"label": "Portrait (9:16)", "value": "9:16"},
    {"label": "Photo (3:2)", "value": "3:2"},
    {"label": "Portrait Photo (2:3)", "value": "2:3"},
  ];
  
  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Get bottom padding based on keyboard state - matches home screen logic
  double _getBottomPadding() {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    if (isKeyboardOpen) {
      return 0; // No padding when keyboard is open to sit directly on it
    } else {
      return 10; // Consistent spacing when keyboard is closed
    }
  }

  // Check if send button should be active
  bool _isSendButtonActive() {
    return _textController.text.trim().isNotEmpty;
  }

  // Show settings bottom sheet
  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // Allow full control over scrolling
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75, // Limit max height
        ),
        decoration: BoxDecoration(
          // Beautiful dark blue gradient matching app design
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              HexColor('#1F2937').withOpacity(0.95),
              HexColor('#111827').withOpacity(0.98),
              Color(0xFF0A0E24), // Deep dark blue
            ],
            stops: [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          border: Border.all(
            color: HexColor('#6366F1').withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: HexColor('#6366F1').withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar with gradient glow - fixed at top
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    HexColor('#3B82F6').withOpacity(0.8),
                    HexColor('#06B6D4').withOpacity(0.6),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(2.r),
                boxShadow: [
                  BoxShadow(
                    color: HexColor('#3B82F6').withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
            
            // Scrollable content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    
                    // Model Selection
                    _buildSettingsSection(
                      title: "Flux Model",
                      content: Column(
                        children: _models.map((model) => 
                          _buildSettingsOption(
                            title: model["label"]!,
                            isSelected: _selectedModel == model["value"],
                            onTap: () {
                              setState(() {
                                _selectedModel = model["value"]!;
                              });
                            },
                          )
                        ).toList(),
                      ),
                    ),
                    
                    // Aspect Ratio Selection
                    _buildSettingsSection(
                      title: "Aspect Ratio",
                      content: Column(
                        children: _aspectRatios.map((ratio) => 
                          _buildSettingsOption(
                            title: ratio["label"]!,
                            isSelected: _selectedAspectRatio == ratio["value"],
                            onTap: () {
                              setState(() {
                                _selectedAspectRatio = ratio["value"]!;
                              });
                            },
                          )
                        ).toList(),
                      ),
                    ),
                    
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build settings section
  Widget _buildSettingsSection({
    required String title,
    required Widget content,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: strFontName,
              ),
            ),
          ),
          content,
        ],
      ),
    );
  }

  // Build individual settings option
  Widget _buildSettingsOption({
    required String title,
    String? subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected 
              ? HexColor('#6366F1').withOpacity(0.1)
              : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? HexColor('#6366F1').withOpacity(0.5) : Colors.white.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: HexColor('#3B82F6').withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12.sp,
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    HexColor('#3B82F6'),
                    HexColor('#06B6D4'),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Handle image selection result
  void _handleImageSelection(dynamic result) {
    if (result != null) {
      setState(() {
        _selectedImages.clear();
        if (result is String) {
          // Single image
          _selectedImages.add(XFile(result));
        } else if (result is List<String>) {
          // Multiple images
          _selectedImages.addAll(result.map((path) => XFile(path)).toList());
        }
      });
    }
  }

  // Remove selected image
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  // Handle generate action
  void _handleGenerate(FluxProvider provider) {
    final message = _textController.text.trim();
    if (message.isNotEmpty) {
      // Generate image with the selected settings
      provider.generateImage(
        prompt: message,
        model: _selectedModel,
        aspectRatio: _selectedAspectRatio,
        images: _selectedImages,
      );
      _textController.clear();
      _focusNode.unfocus();
      setState(() {
        _selectedImages.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FluxProvider>(
      builder: (context, provider, child) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFF000000).withOpacity(0.98), // Exact same as home screen
            border: Border(
              top: BorderSide(
                color: HexColor('#656FE2'), // Same border color as home screen
                width: 1.0,
              ),
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 24.0,
              right: 16.0,
              top: 10,
              bottom: _getBottomPadding(), // Dynamic bottom padding like home screen
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Selected images preview
                if (_selectedImages.isNotEmpty)
                  Container(
                    height: 80,
                    margin: EdgeInsets.only(bottom: 12),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 80,
                          margin: EdgeInsets.only(right: 8),
                          child: Stack(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: HexColor('#656FE2').withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(_selectedImages[index].path),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[800],
                                        child: Icon(
                                          Icons.image,
                                          color: Colors.white.withOpacity(0.5),
                                          size: 30,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.8),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text input field - same styling as home screen
                    TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardAppearance: Brightness.dark,
                      onChanged: (value) {
                        setState(() {}); // Update send button state
                      },
                      scrollPadding: EdgeInsets.zero,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontFamily: strFontName,
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Describe the image you want to generate...',
                        hintStyle: TextStyle(
                          color: HexColor('#9CA3AF'),
                          fontSize: 16.sp,
                          fontFamily: strFontName,
                          fontWeight: FontWeight.w400,
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
                        isDense: true,
                      ),
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: 6,
                      minLines: 1,
                    ),
                  ],
                ),
                SizedBox(height: 10), // Same spacing as home screen
                
                // Button row - same layout as home screen
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side: Flux functional buttons
                    Row(
                      children: [
                        // Image selection button
                        GestureDetector(
                          onTap: () async {
                            dynamic result = await ImageSelectDialog.onImageSelection2(
                              mainContext: context,
                              imageCount: 3, // Allow multiple images
                            );
                            _handleImageSelection(result);
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.add_photo_alternate_outlined,
                              color: Colors.white.withOpacity(0.8),
                              size: 16,
                            ),
                          ),
                        ),
                        SizedBox(width: 8), // Same spacing as home screen
                        
                        // Settings button
                        GestureDetector(
                          onTap: _showSettingsSheet,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.tune_outlined,
                              color: Colors.white.withOpacity(0.8),
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    // Right side: Camera + Send buttons
                    Row(
                      children: [
                        // Camera button
                        GestureDetector(
                          onTap: () async {
                            try {
                              final picker = ImagePicker();
                              final pickedFile = await picker.pickImage(
                                source: ImageSource.camera,
                                imageQuality: 80,
                              );
                              
                              if (pickedFile != null) {
                                setState(() {
                                  _selectedImages.add(pickedFile);
                                });
                              }
                            } catch (e) {
                              print('Error taking photo: $e');
                            }
                          },
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white.withOpacity(0.8),
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 12), // Same spacing as home screen
                        
                        // Send button - exact same styling as home screen
                        Opacity(
                          opacity: _isSendButtonActive() ? 1.0 : 0.5,
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              if (_isSendButtonActive() && !provider.isGenerating) {
                                _handleGenerate(provider);
                              }
                            },
                            child: Image.asset(PNGImages.sendMsg, height: 40, width: 40),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 