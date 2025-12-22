import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import '../../../common_widgets/hexcolor.dart';

class FluxEmptyState extends StatefulWidget {
  @override
  _FluxEmptyStateState createState() => _FluxEmptyStateState();
}

class _FluxEmptyStateState extends State<FluxEmptyState>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  
  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _rotationController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Flux logo
          AnimatedBuilder(
            animation: Listenable.merge([_pulseController, _rotationController]),
            builder: (context, child) {
              return Container(
                width: 120.w,
                height: 120.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer rotating ring
                    Transform.rotate(
                      angle: _rotationController.value * 2 * pi,
                      child: Container(
                        width: 120.w,
                        height: 120.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(
                            colors: [
                              HexColor('#7C3AED').withOpacity(0.3),
                              HexColor('#3B82F6').withOpacity(0.6),
                              HexColor('#10B981').withOpacity(0.9),
                              HexColor('#7C3AED').withOpacity(0.3),
                            ],
                            stops: [0.0, 0.33, 0.66, 1.0],
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF0A0E24),
                          ),
                        ),
                      ),
                    ),
                    
                    // Inner pulsing circle
                    Transform.scale(
                      scale: 0.8 + 0.2 * _pulseController.value,
                      child: Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              HexColor('#7C3AED'),
                              HexColor('#3B82F6'),
                              HexColor('#10B981').withOpacity(0.8),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: HexColor('#7C3AED').withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.auto_fix_high,
                          color: Colors.white,
                          size: 40.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
          SizedBox(height: 40.h),
          
          // Title
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                HexColor('#7C3AED'),
                HexColor('#3B82F6'),
                HexColor('#10B981'),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            child: Text(
              'Flux AI',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
          ),
          
          SizedBox(height: 12.h),
          
          // Subtitle
          Text(
            'Advanced Image Generation',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          
          SizedBox(height: 8.h),
          
          Text(
            'Black Forest Labs Text-to-Image Model',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          
          SizedBox(height: 40.h),
          
          // Feature highlights
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.05),
                  Colors.white.withOpacity(0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                _buildFeatureItem(
                  icon: Icons.photo_camera,
                  title: 'Photorealistic Images',
                  description: 'Generate stunning, high-quality images',
                  color: HexColor('#3B82F6'),
                ),
                
                SizedBox(height: 16.h),
                
                _buildFeatureItem(
                  icon: Icons.palette,
                  title: 'Style Variation',
                  description: 'Multiple artistic styles and formats',
                  color: HexColor('#7C3AED'),
                ),
                
                SizedBox(height: 16.h),
                
                _buildFeatureItem(
                  icon: Icons.speed,
                  title: 'Fast Generation',
                  description: 'Quick results with advanced optimization',
                  color: HexColor('#10B981'),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 30.h),
          
          // Call to action
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  HexColor('#7C3AED').withOpacity(0.2),
                  HexColor('#3B82F6').withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: HexColor('#656FE2').withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white.withOpacity(0.8),
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Start generating below',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                color.withOpacity(0.3),
                color.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20.sp,
          ),
        ),
        
        SizedBox(width: 16.w),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 