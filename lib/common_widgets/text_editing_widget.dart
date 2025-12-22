import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:OneBrain/base/base_stateful_state.dart';
import '../resources/color.dart';
import '../resources/strings.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
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
  final Color? fieldBorderClr;
  final double? borderRadius;
  final double? contentPadding;
  final Color? bgColor;
  final bool? isShadow;

  const CustomTextField(
      {super.key,
      this.hint,
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
      this.suffixFontSize,
      this.fieldBorderClr,
      this.borderRadius,
      this.textHeight,
      this.contentPadding,
        this.bgColor,
        this.isShadow = true
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 56.h,
      width: width,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: bgColor ?? HexColor('#1F2937'),
        border: Border.all(color: focusColor ?? HexColor('#6B7280'), width: 1),
        borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
      ),
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
        textAlign: textAlign ?? TextAlign.left,
        keyboardType: textInputType,
        keyboardAppearance: Brightness.dark,
        expands: expands,
        style: TextStyle(
            color: Colors.white,
            fontSize: fontSize ?? 12.sp,
            fontFamily: fontFamilyText ?? strFontName,
            fontWeight: fontWeightText ?? FontWeight.w700,
            height: textHeight),
        cursorColor: colorPrimary,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        decoration: InputDecoration(
          enabled: true,
          counterText: counterText ?? "",
          isDense: isDense,
          prefixIcon: prefixIcon != null
              ? SvgPicture.asset(
                  prefixIcon!,
                  height: 20.h,
                  width: 20.w,
                  fit: BoxFit.scaleDown,
                  colorFilter: focusColor != null ? ColorFilter.mode(colorPrimary, BlendMode.srcIn) : null,
                )
              : prefix,
          focusColor: Colors.black12,
          suffixText: suffixText,
          suffix: suffix,
          labelStyle: TextStyle(
            color: colorBDB5D2,
            fontFamily: strFontName,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
          label: Text(
            hint ?? "",
          ),
          suffixStyle: TextStyle(
            color: colorBDB5D2,
            fontSize: suffixFontSize ?? 14.sp,
            fontFamily: suffixFontFamilyText ?? strFontName,
            fontWeight: suffixFontWeightText ?? FontWeight.w400,
          ),
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(
          //       color: fieldBorderClr ?? Colors.transparent, width: 2.0),
          //   borderRadius: BorderRadius.circular(borderRadius ?? 16.0),
          // ),
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
          contentPadding: EdgeInsets.symmetric(horizontal: horizontalContentPadding ?? 12.w, vertical: verticalContentPadding ?? 12.h),
          hintStyle: TextStyle(
            color: hintColor ?? HexColor('#6B7280'),
            fontSize: 12.sp,
            fontFamily: fontFamilyHint ?? strFontName,
            fontWeight: fontWeightHint ?? FontWeight.w400,
          ),
          filled: true,
          fillColor: Colors.transparent,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

/// ======================================= ///
class CustomTextField1 extends StatelessWidget {
  final String? hint, labelText, initialValue, fontFamilyText, fontFamilyHint, counterText, prefixIconName, fontFamilyLabel;
  final Widget? prefixIcon;
  final Color? color;
  final Color? textColor;
  final Color? hintColor;
  final Color? labelColor;
  final Color? suffixIconColor;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? readOnly;
  final TextAlign? textAlign;
  final Widget? suffixIcon;
  final TextInputType? textInputType;
  final int? maxLines;
  final bool? isDense;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onTapSuffixIcon;
  final double? height;
  final double? width;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool isShadowEnable;
  final bool isBorderEnable;
  final FontWeight? fontWeightText;
  final FontWeight? fontWeightHint;
  final FontWeight? fontWeightLabel;
  final String? suffixIconName;
  final Widget? suffixIconWidget;
  final double? suffixIconHeight;
  final double? suffixIconWidth;
  final bool passwordVisible;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final bool autoFocus;
  final bool expands;
  final double? fontSize, labelSize, hintSize, borderRadius, contentPaddingHorizontal, contentPaddingVertical;
  final BoxConstraints? prefixIconConstraints;
  final BoxShadow? isShadow;
  final double? suffixIcnHeight;
  final double? suffixIcnWidth;
  final double? borderRadiusContainer;
  final double? focusBorderRadius;
  final double? borderRadiusEnable;
  final double? borderRadiusForTextField;

  const CustomTextField1(
      {super.key,
      this.hint,
      this.labelText,
      this.hintSize,
      this.labelSize,
      this.expands = false,
      this.autoFocus = false,
      this.prefixIconConstraints,
      this.prefixIconName,
      this.prefixIcon,
      this.color,
      this.controller,
      this.focusNode,
      this.initialValue,
      this.readOnly,
      this.textAlign,
      this.suffixIcon,
      this.suffixIconColor,
      this.textInputType,
      this.maxLines = 1,
      this.isDense,
      this.onTap,
      this.height,
      this.onFieldSubmitted,
      this.validator,
      this.maxLength,
      this.textInputAction,
      this.textCapitalization,
      this.inputFormatters,
      this.width,
      this.hintColor,
      this.textColor,
      this.labelColor,
      this.isBorderEnable = true,
      this.isShadowEnable = true,
      this.fontFamilyText,
      this.fontFamilyHint,
      this.fontWeightHint,
      this.fontWeightLabel,
      this.fontFamilyLabel,
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
      this.borderRadius,
      this.fontSize,
      this.contentPaddingHorizontal,
      this.contentPaddingVertical,
        this.isShadow,
        this.suffixIcnHeight,
        this.suffixIcnWidth,
        this.borderRadiusContainer,
        this.focusBorderRadius,
      this.borderRadiusEnable,
      this.borderRadiusForTextField
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular( borderRadiusContainer ?? 15.0),
        // border: Border.all(color: color8396B6, width: 1.sp),
        boxShadow:  [
          isShadow ??
          BoxShadow(
            color: colorBlack.withOpacity(.08),
            blurRadius: 4,
            spreadRadius: -1,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: TextFormField(
        autofocus: autoFocus,
        inputFormatters: inputFormatters,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
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
        textAlign: textAlign ?? TextAlign.left,
        keyboardType: textInputType,
        keyboardAppearance: Brightness.dark,
        expands: expands,
        cursorColor: colorPrimary,
        style: TextStyle(
          color: textColor ?? colorBlack,
          fontSize: fontSize ?? 14.sp,
          fontFamily: fontFamilyText ?? strFontName,
          fontWeight: fontWeightText ?? FontWeight.w500,
        ),
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        decoration: InputDecoration(
          enabled: true,
          counterText: counterText ?? "",
          isDense: isDense ?? isDense,
          suffixIconColor: colorPrimary,
          focusColor: colorPrimary,
          prefixIcon: prefixIconName?.isNotEmpty ?? false
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: SvgPicture.asset(
                    prefixIconName!,
                    height: 24.h,
                    width: 24.w,
                    fit: BoxFit.scaleDown,
                  ),
                )
              : prefixIcon,
          suffixIcon: suffixIconWidget ??
              (suffixIconName != null
                  ? GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onTapSuffixIcon,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                        child: SvgPicture.asset(
                          suffixIconName!,
                          height: suffixIcnHeight ?? 24.h,
                          width:  suffixIcnWidth ?? 24.w,
                          fit: BoxFit.fill,
                        ),
                      ))
                  : null),
          hintText: hint,
          errorMaxLines: 2,
          contentPadding: EdgeInsets.symmetric(horizontal: contentPaddingHorizontal ?? 12.w, vertical: contentPaddingVertical ?? 16.h),
          hintStyle: TextStyle(
            color: hintColor ?? color0B0B40.withOpacity(.3),
            fontSize: hintSize ?? 14.sp,
            fontFamily: fontFamilyHint ?? strFontName,
            fontWeight: fontWeightHint ?? FontWeight.w300,
          ),
          filled: true,
          prefixIconConstraints: prefixIconConstraints,
          fillColor: color ?? Colors.white,
          // border: UnderlineInputBorder(
          //   borderSide: BorderSide.none,
          //   borderRadius: BorderRadius.circular(13.0),
          // ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: colorE3EAF4, width: 1.sp),
            borderRadius: BorderRadius.circular( focusBorderRadius ??13.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorE3EAF4, width: 1.sp),
            borderRadius: BorderRadius.circular( focusBorderRadius ?? 13.0),
          ),
          focusedBorder: OutlineInputBorder(
            gapPadding: 0.0,
            // borderSide: BorderSide.none,
            borderSide: BorderSide(color: colorE3EAF4, width: 1.sp),
            borderRadius: BorderRadius.circular(focusBorderRadius ?? 13.0),
          ),
          // labelText: labelText,
          // labelStyle: TextStyle(
          //   colcolorPrimaryor: labelColor ?? colorBlack.withOpacity(0.6),
          //   fontSize: labelSize ?? 13.sp,
          //   fontFamily: fontFamilyLabel ?? strFontName,
          //   fontWeight: fontWeightLabel ?? FontWeight.w400,
          // ),
        ),
      ),
    );
  }
}



