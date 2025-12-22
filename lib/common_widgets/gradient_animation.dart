import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:OneBrain/common_widgets/text_widget.dart';

class GradientTextAnimationScreen extends StatefulWidget {
  final String text;
  final double fontSize;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool autoSize;
  final double? minFontSize;
  final double? maxFontSize;

  const GradientTextAnimationScreen({
    super.key, 
    required this.text, 
    this.fontSize = 18,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.autoSize = false,
    this.minFontSize,
    this.maxFontSize,
  });

  @override
  State<GradientTextAnimationScreen> createState() => _GradientTextAnimationScreenState();
}

class _GradientTextAnimationScreenState extends State<GradientTextAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 8000), // Optimized duration for smoother performance
      vsync: this,
    )..repeat(); // Keep the animation looping indefinitely

    // Use linear animation for consistent performance
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary( // Isolate repaints for better performance
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return ShaderMask(
            shaderCallback: (bounds) {
              // Simplified gradient calculation for better performance
              final double progress = _animation.value;
              final double textWidth = bounds.width;
              
              // Reduced gradient complexity while maintaining visual quality
              final double gradientWidth = textWidth * 3.0; // Reduced from 6.0
              final double totalRange = textWidth + gradientWidth;
              
              // Optimized movement calculation
              final double offset = (progress * totalRange) - (gradientWidth * 0.5);
              final double startX = offset - textWidth;
              final double endX = offset + textWidth;
              
              return ui.Gradient.linear(
                Offset(startX, 0),
                Offset(endX, 0),
                // Optimized gradient with fewer colors for better performance
                const [
                  Color(0xFF1E40AF), // Dark blue
                  Color(0xFF3B82F6), // Bright blue
                  Color(0xFF60A5FA), // Light blue
                  Color(0xFFBFDBFE), // Very light blue
                  Color(0xFFF0F9FF), // Peak white/glow
                  Color(0xFFBFDBFE), // Very light blue
                  Color(0xFF60A5FA), // Light blue
                  Color(0xFF3B82F6), // Bright blue
                  Color(0xFF1E40AF), // Dark blue
                ],
                // Optimized stops for better performance
                const [0.0, 0.15, 0.3, 0.42, 0.50, 0.58, 0.7, 0.85, 1.0],
                TileMode.repeated,
              );
            },
            child: child!,
          );
        },
        child: widget.autoSize
            ? AutoSizeText(
                widget.text,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                maxLines: widget.maxLines,
                overflow: widget.overflow ?? TextOverflow.ellipsis,
                minFontSize: widget.minFontSize ?? 12,
                maxFontSize: widget.maxFontSize ?? widget.fontSize,
              )
            : TextWidget(
                text: widget.text,
                fontSize: widget.fontSize,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
                maxLines: widget.maxLines,
                textOverflow: widget.overflow,
              ),
      ),
    );
  }
}
