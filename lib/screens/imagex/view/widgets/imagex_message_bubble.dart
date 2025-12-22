import 'dart:io';
import 'dart:ui';
import 'package:OneBrain/common_widgets/hexcolor.dart';
import 'package:OneBrain/resources/image.dart';
import 'package:OneBrain/screens/imagex/models/imagex_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:shimmer/shimmer.dart';

class ImageXMessageBubble extends StatefulWidget {
  final ImageXMessageModel message;
  const ImageXMessageBubble({super.key, required this.message});

  @override
  State<ImageXMessageBubble> createState() => _ImageXMessageBubbleState();
}

class _ImageXMessageBubbleState extends State<ImageXMessageBubble> {
  @override
  Widget build(BuildContext context) {
    final messages = widget.message;
    final isUser = messages.isUser;

    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isUser) botHeader(),
          if (!isUser) botContent(),
          if (isUser) userContent(),
        ],
      ),
    );
  }

  Widget botHeader() {
    final isGenerating = widget.message.isGenerating;

    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          botAvatar(),
          SizedBox(width: 8.w),
          isGenerating
              ? Shimmer.fromColors(
                baseColor: Colors.white.withValues(alpha: 0.3),
                highlightColor: Colors.white.withValues(alpha: 0.6),
                child: Text(
                  "ImageX is Processing...",
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              )
              : Text(
                "ImageX",
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
        ],
      ),
    );
  }

  Widget botContent() {
    final message = widget.message;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SHOW ERROR TEXT ONLY (NO COPY BUTTON)
        if (message.isError)
          Padding(padding: EdgeInsets.only(top: 6.h), child: replayText()),
        if (message.isError)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: message.content));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text("Copied to clipboard"),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 4.w, top: 6.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.copy_rounded,
                        size: 16.w,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "Copy",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        // IMAGE RENDERING
        if (!message.isError &&
            (message.isGenerating ||
                (message.imageUrl != null && !message.hasMultipleImages)))
          botImageDynamic(message),

        if (!message.isGenerating &&
            message.hasMultipleImages &&
            !message.isError)
          botMultiple(message.imageUrls!),
      ],
    );
  }

  Widget userContent() {
    final message = widget.message;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (message.hasLocalImages)
          userSelectedImages(message.userLocalImages!),
        if (message.hasTextContent) userText(),
      ],
    );
  }

  Widget botAvatar() {
    return SizedBox(
      width: 36.w,
      height: 36.w,
      child: Image.asset(
        'assets/ai_icon/max_black.png',
        colorBlendMode: BlendMode.srcIn,
      ),
    );
  }

  // --------------------------------------------------------------------------
  Widget replayText() {
    return Text(
      widget.message.content,
      style: TextStyle(
        fontSize: 15.sp,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget botImageDynamic(ImageXMessageModel message) {
    final bool isGenerating = message.isGenerating == true;

    final partialUrl =
        message.metadata != null
            ? message.metadata!['partialImage'] as String?
            : null;

    final finalUrl =
        message.imageUrl ??
        (message.imageUrls != null && message.imageUrls!.isNotEmpty
            ? message.imageUrls!.first
            : null);

    final bool hasPartial = partialUrl != null;
    final bool hasFinal = finalUrl != null;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: 0.35),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: SizedBox(
          height: 280.h,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Loader state
              if (isGenerating && !hasFinal)
                Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(PNGImages.chatLoadingImage, fit: BoxFit.cover),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.15),
                      ),
                    ),
                  ],
                ),

              // Partial image
              if (hasPartial) Image.network(partialUrl, fit: BoxFit.cover),

              // Final image
              if (hasFinal)
                Image.network(
                  finalUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress != null) {
                      return Image.asset(
                        PNGImages.chatLoadingImage,
                        fit: BoxFit.cover,
                      );
                    }
                    return child;
                  },
                ),

              // Generating text label
              if (isGenerating && !hasFinal)
                Positioned(
                  left: 12.w,
                  bottom: 12.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 6.h,
                      horizontal: 10.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      "Generating...",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              if (hasFinal || hasPartial)
                Positioned(
                  right: 10.w,
                  bottom: 5.h,
                  child: GestureDetector(
                    onTap: () => downloadImage(),
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                            color: Colors.black.withValues(alpha: 0.35),
                          ),
                        ],
                        color: Colors.black.withValues(alpha: 0.45),
                      ),
                      child: Icon(
                        Icons.download_rounded,
                        size: 20.w,
                        color: Colors.white.withValues(alpha: 0.95),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget botMultiple(List<String> urls) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...urls.map(
          (e) => botImageDynamic(
            widget.message.copyWith(
              imageUrl: e,
              imageUrls: [e],
              isGenerating: false,
            ),
          ),
        ),
      ],
    );
  }

  Widget userText() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF14366e),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(2.r),
          bottomLeft: Radius.circular(16.r),
          bottomRight: Radius.circular(16.r),
        ),
        border: Border.all(
          width: 1,
          color: HexColor('#A855F7').withValues(alpha: 0.3),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      child: Text(
        widget.message.content,
        style: TextStyle(fontSize: 16.sp, color: Colors.white),
      ),
    );
  }

  Widget userSelectedImages(List<String> paths) {
    return Column(
      children:
          paths
              .map(
                (p) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.file(File(p), width: 240.w, fit: BoxFit.cover),
                  ),
                ),
              )
              .toList(),
    );
  }

  Future<void> downloadImage() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator.adaptive()),
    );

    try {
      final url =
          widget.message.imageUrl ?? (widget.message.imageUrls?.first ?? "");
      if (url.isEmpty) {
        Navigator.pop(context);
        return;
      }

      // Permission for older Android
      await Permission.storage.request();

      // Download image via Dio
      final response = await Dio().get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      final Uint8List data = Uint8List.fromList(response.data);

      final fileName = "image_${DateTime.now().millisecondsSinceEpoch}.png";

      // Save using SaverGallery (Android + iOS)
      await SaverGallery.saveImage(
        data,
        quality: 100,
        fileName: fileName,
        skipIfExists: false,
        androidRelativePath: "Pictures/OneBrain",
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Text("Image saved successfully to gallery"),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      print('--- Image Save Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Text("Failed to save image"),
        ),
      );
    }
  }
}
