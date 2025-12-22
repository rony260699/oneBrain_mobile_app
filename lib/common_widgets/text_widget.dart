import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/color.dart';

class TextWidget extends StatelessWidget {
  final String? text;
  final Color? color;
  final FontStyle? fontStyle;
  final double? fontSize;
  final double? letterSpacing;
  final TextAlign? textAlign;
  final GestureTapCallback? onTap;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final double? textHeight;
  final TextStyle? textStyle;
  final TextDecoration? decoration;

  const TextWidget({
    super.key,
    this.text,
    this.color = color0B0B40,
    this.fontSize,
    this.fontFamily = '.SF Pro Text', // iOS system font
    this.letterSpacing,
    this.textAlign,
    this.onTap,
    this.fontWeight = FontWeight.normal,
    this.textOverflow,
    this.maxLines,
    this.textHeight,
    this.textStyle,
    this.decoration,
    this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    // Performance optimization: Use RepaintBoundary for text widgets
    return RepaintBoundary(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Text(
          text ?? '',
          textAlign: textAlign ?? TextAlign.left,
          maxLines: maxLines,
          softWrap: true,
          overflow: textOverflow,
          // Performance optimization: Disable text scaling for consistent rendering
          textScaler: TextScaler.linear(1.0),
          style:
              textStyle ??
              TextStyle(
                color: color ?? color0B0B40,
                height: textHeight,
                fontSize: fontSize ?? 14.sp,
                letterSpacing: letterSpacing,
                decoration: decoration,
                fontFamily: fontFamily ?? '.SF Pro Text', // iOS system font
                fontWeight: fontWeight,
                fontStyle: fontStyle,
                // Performance optimization: Enable text rendering optimizations
                leadingDistribution: TextLeadingDistribution.even,
              ),
        ),
      ),
    );
  }
}
