import 'dart:io';
import 'package:OneBrain/screens/imagex/controller/imagex_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common_widgets/hexcolor.dart';
import '../../../../common_widgets/image_select_dialog.dart';
import '../../../../resources/image.dart';
import '../../../../resources/strings.dart';

class ImageXChatBar extends StatefulWidget {
  final ScrollController scrollController;

  const ImageXChatBar({super.key, required this.scrollController});

  @override
  ImageXChatBarState createState() => ImageXChatBarState();
}

class ImageXChatBarState extends State<ImageXChatBar> {
  @override
  void dispose() {
    super.dispose();
  }

  // Show settings bottom sheet
  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setModalState) => Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.75,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        HexColor('#1F2937').withValues(alpha: 0.95),
                        HexColor('#111827').withValues(alpha: 0.98),
                        Color(0xFF0A0E24),
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                    border: Border.all(
                      color: HexColor('#6366F1').withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: HexColor('#6366F1').withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 12.h),
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              HexColor('#3B82F6').withValues(alpha: 0.8),
                              HexColor('#06B6D4').withValues(alpha: 0.6),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(2.r),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8,
                              offset: const Offset(0, 0),
                              color: HexColor('#3B82F6').withValues(alpha: 0.3),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 20.h,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 20.h),
                              // Size Selection
                              buildSettingsSection(
                                title: "Image Size",
                                content: Obx(() {
                                  final controller =
                                      Get.find<ImageXController>();
                                  return Column(
                                    children:
                                        controller.availableSizes
                                            .map(
                                              (size) => buildSettingsOption(
                                                title: size["label"]!,
                                                isSelected:
                                                    controller
                                                        .selectedSize
                                                        .value ==
                                                    size["value"],
                                                onTap: () {
                                                  controller.setSize(
                                                    size["value"]!,
                                                  );
                                                  setModalState(() {});
                                                },
                                              ),
                                            )
                                            .toList(),
                                  );
                                }),
                              ),
                              // int getTokenCost(String quality) =>_tokenCosts[selectedSize.value]?[quality] ?? 0;

                              // Quality Selection
                              buildSettingsSection(
                                title: "Image Quality",
                                content: Obx(() {
                                  final controller =
                                      Get.find<ImageXController>();
                                  return Column(
                                    children:
                                        controller.availableQualities
                                            .map(
                                              (quality) => buildSettingsOption(
                                                title: quality["label"]!,
                                                subtitle:
                                                    "~${controller.getTokenCost(quality["value"]!)} tokens",
                                                isSelected:
                                                    controller
                                                        .selectedQuality
                                                        .value ==
                                                    quality["value"],
                                                onTap: () {
                                                  controller.setQuality(
                                                    quality["value"]!,
                                                  );
                                                  setModalState(() {});
                                                },
                                              ),
                                            )
                                            .toList(),
                                  );
                                }),
                              ),
                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  Widget buildSettingsSection({
    required String title,
    required Widget content,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          content,
        ],
      ),
    );
  }

  Widget buildSettingsOption({
    String? subtitle,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          gradient:
              isSelected
                  ? LinearGradient(
                    colors: [
                      HexColor('#A855F7').withValues(alpha: 0.1),
                      HexColor('#3B82F6').withValues(alpha: 0.1),
                      HexColor('#06B6D4').withValues(alpha: 0.1),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    tileMode: TileMode.clamp,
                  )
                  : null,
          borderRadius: BorderRadius.circular(12.r),
          color: !isSelected ? Colors.white.withValues(alpha: 0.05) : null,
          border: Border.all(
            width: 1.5,
            color:
                isSelected
                    ? HexColor('#6366F1').withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.1),
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: HexColor('#3B82F6').withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
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
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              ShaderMask(
                shaderCallback:
                    (bounds) => LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [HexColor('#3B82F6'), HexColor('#06B6D4')],
                    ).createShader(bounds),
                child: Icon(
                  size: 20.sp,
                  Icons.check_circle,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ImageXController>();

    return Obx(
      () => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF000000).withValues(alpha: 0.98),
          border: Border(
            top: BorderSide(color: HexColor('#656FE2'), width: 1.0),
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 24.0,
            right: 16.0,
            bottom: controller.getBottomPadding(context),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.selectedImages.isNotEmpty)
                Container(
                  height: 80,
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.selectedImages.length,
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
                                  width: 1,
                                  color: HexColor(
                                    '#656FE2',
                                  ).withValues(alpha: 0.3),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(controller.selectedImages[index].path),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[800],
                                      child: Icon(
                                        size: 30,
                                        Icons.image,
                                        color: Colors.white.withValues(
                                          alpha: 0.5,
                                        ),
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
                                onTap: () => controller.removeImage(index),
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red.withValues(alpha: 0.8),
                                  ),
                                  child: Icon(
                                    size: 12,
                                    Icons.close,
                                    color: Colors.white,
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
                  TextField(
                    minLines: 1,
                    maxLines: 6,
                    scrollPadding: EdgeInsets.zero,
                    focusNode: controller.focusNode,
                    keyboardAppearance: Brightness.dark,
                    controller: controller.textController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    onChanged: (value) => controller.update(),
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(
                      height: 1.3,
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontFamily: strFontName,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      hintStyle: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: strFontName,
                        color: HexColor('#9CA3AF'),
                        fontWeight: FontWeight.w400,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: 'Describe what you want to see...',
                      contentPadding: EdgeInsets.symmetric(vertical: 6),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Image selection button
                      GestureDetector(
                        onTap:
                            !controller.canAddMoreImages()
                                ? null
                                : () async {
                                  dynamic result =
                                      await ImageSelectDialog.onImageSelection2(
                                        mainContext: context,
                                        imageCount:
                                            controller.maxImages -
                                            controller.selectedImages.length,
                                      );
                                  controller.handleImageSelection(result);
                                },
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color:
                                !controller.canAddMoreImages()
                                    ? Colors.white.withValues(alpha: 0.05)
                                    : Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.add_photo_alternate_outlined,
                            color:
                                !controller.canAddMoreImages()
                                    ? Colors.white.withValues(alpha: 0.3)
                                    : Colors.white.withValues(alpha: 0.8),
                            size: 16,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      // Settings button
                      GestureDetector(
                        onTap: _showSettingsSheet,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            size: 16,
                            Icons.tune_outlined,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Opacity(
                    opacity: controller.isSendButtonActive ? 1.0 : 0.5,
                    child: InkWell(
                      onTap:
                          controller.isSendButtonActive
                              ? () {
                                final message =
                                    controller.textController.text.trim();
                                if (message.isNotEmpty) {
                                  controller.sendMessage(
                                    prompt: message,
                                    images: controller.selectedImages.toList(),
                                  );
                                  controller.clearInput();
                                }
                              }
                              : null,
                      child: Image.asset(
                        width: 40,
                        height: 40,
                        PNGImages.sendMsg,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
