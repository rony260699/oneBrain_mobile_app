import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class ImageXEmptyState extends StatefulWidget {
  const ImageXEmptyState({super.key});

  @override
  ImageXEmptyStateState createState() => ImageXEmptyStateState();
}

class ImageXEmptyStateState extends State<ImageXEmptyState> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(
          'https://digitxevents.com/wp-content/uploads/2025/05/ai-image-generator-upd.webm',
        ),
      )
      ..initialize().then((_) {
        if (mounted) {
          _controller.setLooping(true);
          _controller.play();
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Color(0xFF656FE2), width: 2.w),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.4),
                blurRadius: 20.r,
                spreadRadius: 2.r,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Color(
                  0xFF1a1a2e,
                ), // Dark background that matches your theme
                child:
                    _controller.value.isInitialized
                        ? VideoPlayer(_controller)
                        : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF1a1a2e),
                                Color(0xFF16213e),
                                Color(0xFF0f3460),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // ImageX logo placeholder
                                Container(
                                  width: 80.w,
                                  height: 80.h,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF656FE2).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(40.r),
                                    border: Border.all(
                                      color: Color(0xFF656FE2).withOpacity(0.3),
                                      width: 2.w,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: 40.w,
                                    color: Color(0xFF656FE2),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'ImageX',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'AI Image Generator',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
