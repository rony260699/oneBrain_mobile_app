import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../resources/color.dart';
import '../resources/strings.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final String? label;
  final String? suffixText;
  final String? prefixIcon;
  final Widget? suffixWidget;
  final Color? color;
  final Color? hintColor, focusColor;
  final TextEditingController? controller;
  final TextCapitalization? textCapitalization;
  final FocusNode? focusNode;
  final String? initialValue;
  final bool? readOnly;
  final TextAlign? textAlign;
  final Widget? suffix, prefix;
  final TextInputType? textInputType;
  final int? maxLines;
  final int? minLines;
  final bool? isDense;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onTapSuffixIcon;
  final double? height;
  final double? horizontalContentPadding;
  final double? verticalContentPadding;
  final double? textHeight;
  final double? width;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool isShadowEnable;
  final bool isBorderEnable;
  final String? fontFamilyText;
  final String? suffixFontFamilyText;
  final String? fontFamilyHint;
  final FontWeight? fontWeightText;
  final FontWeight? suffixFontWeightText;
  final FontWeight? fontWeightHint;
  final String? suffixIconName;
  final Widget? suffixIconWidget;
  final double? suffixIconHeight;
  final double? suffixIconWidth;
  final bool passwordVisible;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final bool autoFocus;
  final bool expands;
  final double? fontSize;
  final double? suffixFontSize;
  final TextAlignVertical? textAlignVertical;
  final String? counterText;
  final Color? fieldBorderClr, fontColor;
  final double? borderRadius;
  final double? contentPadding;

  const CustomTextField(
      {super.key,
      this.hint,
      this.label,
      this.suffixText,
      this.suffixWidget,
      this.expands = false,
      this.autoFocus = false,
      this.prefixIcon,
      this.prefix,
      this.color,
      this.focusColor,
      this.controller,
      this.textAlignVertical,
      this.textCapitalization,
      this.focusNode,
      this.initialValue,
      this.readOnly,
      this.textAlign,
      this.suffix,
      this.textInputType,
      this.maxLines = 1,
      this.minLines,
      this.isDense,
      this.onTap,
      this.height,
      this.onFieldSubmitted,
      this.verticalContentPadding,
      this.horizontalContentPadding,
      this.validator,
      this.maxLength,
      this.textInputAction,
      this.inputFormatters,
      this.width,
      this.hintColor,
      this.isBorderEnable = true,
      this.isShadowEnable = false,
      this.fontFamilyText,
      this.suffixFontFamilyText,
      this.suffixFontWeightText,
      this.fontFamilyHint,
      this.fontWeightHint,
      this.fontWeightText,
      this.suffixIconName,
      this.suffixIconHeight,
      this.suffixIconWidth,
      this.onTapSuffixIcon,
      this.passwordVisible = false,
      this.suffixIconWidget,
      this.onChanged,
      this.onEditingComplete,
      this.counterText,
      this.fontSize,
      this.fontColor,
      this.suffixFontSize,
      this.fieldBorderClr,
      this.borderRadius,
      this.textHeight,
      this.contentPadding});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 58.h,
      width: width,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: color ?? colorWhite,
        border: Border.all(color: focusColor ?? colorDDD6EF, width: 1.sp),
        borderRadius: BorderRadius.circular(borderRadius ?? 12.sp),
      ),
      child: Align(
        // alignment: Alignment.bottomCenter,
        child: TextFormField(
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          // TextCapitalization.sentences,
          textAlignVertical: textAlignVertical ?? TextAlignVertical.center,
          autofocus: autoFocus,
          inputFormatters: inputFormatters,
          textInputAction: textInputAction,
          validator: validator,
          onTap: onTap,
          obscureText: passwordVisible,
          maxLength: maxLength,
          controller: controller,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          initialValue: initialValue,
          readOnly: readOnly ?? false,
          maxLines: maxLines,
          minLines: minLines ?? 1,
          textAlign: textAlign ?? TextAlign.start,
          keyboardType: textInputType,
          keyboardAppearance: Brightness.dark,
          expands: expands,
          // cursorHeight: 20,
          style: TextStyle(
              color: fontColor ?? color170B37,
              fontSize: fontSize ?? 14.sp,
              fontFamily: fontFamilyText ?? strFontName,
              fontWeight: fontWeightText ?? FontWeight.w600,
              height: textHeight),
          cursorColor: colorPrimary,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          decoration: InputDecoration(
            enabled: true,
            // alignLabelWithHint: true,
            counterText: counterText ?? "",
            isDense: isDense,
            prefixIcon: prefixIcon != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 18.w),
                      SvgPicture.asset(
                        prefixIcon!,
                        height: 20.h,
                        width: 20.w,
                        fit: BoxFit.scaleDown,
                        colorFilter: focusColor != null ? ColorFilter.mode(colorPrimary, BlendMode.srcIn) : null,
                      ),
                      Container(
                        height: 30.h,
                        width: 1.w,
                        color: colorDFDFEE,
                        margin: EdgeInsets.symmetric(horizontal: 12.w),
                      )
                    ],
                  )
                : prefix,
            focusColor: Colors.black12,
            suffixText: suffixText,
            suffix: suffix,
            labelStyle: TextStyle(
              color: colorWhite.withOpacity(0.5),
              fontFamily: strFontName,
              fontSize: 14.sp,
              fontWeight: FontWeight.w300,
            ),
            label: label != null
                ? null
                : Text(
                    hint ?? "",
                    style: TextStyle(
                      color: hintColor ?? colorBDB5D2,
                      fontSize: 14.sp,
                      fontFamily: fontFamilyHint ?? strFontName,
                      fontWeight: fontWeightHint ?? FontWeight.w300,
                    ),
                  ),
            hintText: label,
            suffixStyle: TextStyle(
              color: colorWhite,
              fontSize: suffixFontSize ?? 14.sp,
              fontFamily: suffixFontFamilyText ?? strFontName,
              fontWeight: suffixFontWeightText ?? FontWeight.w400,
            ),
            suffixIcon: suffixIconWidget ??
                (suffixIconName != null
                    ? GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onTapSuffixIcon,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            suffixIconName!,
                            width: suffixIconWidth,
                            height: suffixIconHeight,
                            fit: BoxFit.scaleDown,
                            colorFilter: focusColor != null ? ColorFilter.mode(colorPrimary, BlendMode.srcIn) : null,
                          ),
                        ))
                    : null),
            // hintText: hint,
            contentPadding: EdgeInsets.symmetric(horizontal: horizontalContentPadding ?? 14.w, vertical: verticalContentPadding ?? 8.h),
            hintStyle: TextStyle(
              color: hintColor ?? color798497,
              fontSize: 14.sp,
              fontFamily: fontFamilyHint ?? strFontName,
              fontWeight: fontWeightHint ?? FontWeight.w500,
            ),
            filled: true,
            fillColor: Colors.transparent,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
