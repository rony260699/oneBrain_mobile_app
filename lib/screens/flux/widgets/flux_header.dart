import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/hexcolor.dart';
import '../../../resources/strings.dart';

class FluxHeader extends StatelessWidget {
  const FluxHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Row(
        children: [
          // Clean and elegant back button
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
          ),

          SizedBox(width: 20.w),

          // Enhanced title and subtitle - centered
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title with enhanced gradient and glow effect
                ShaderMask(
                  shaderCallback:
                      (bounds) => LinearGradient(
                        colors: [
                          HexColor('#7C3AED'),
                          HexColor('#3B82F6'),
                          HexColor('#10B981'),
                          HexColor('#F59E0B'),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                  child: Text(
                    'Flux',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: strFontName,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: HexColor('#7C3AED').withOpacity(0.5),
                          blurRadius: 15,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 6.h),

                // Enhanced subtitle with shimmer effect
                Text(
                  'AI Image Generator',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.85),
                    fontFamily: strFontName,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Spacer to balance the layout
          SizedBox(width: 64.w),
        ],
      ),
    );
  }
}
