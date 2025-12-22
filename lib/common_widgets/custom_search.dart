import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:OneBrain/base/base_stateful_state.dart';

import '../resources/color.dart';
import '../resources/strings.dart';

class CustomSearch extends StatelessWidget {
  final String? hint;
  final String? label;
  final String? suffixText;
  final String? prefixIcon;
  final Widget? suffixWidget;
  final Color? color;
  final Color? hintColor, focusColor, borderColor;
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
  final Color? fieldBorderClr;
  final double? borderRadius;
  final double? contentPadding;
  final bool? enabled;
  final bool? isObscureText;

  const CustomSearch({
    super.key,
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
    this.borderColor,
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
    this.suffixFontSize,
    this.fieldBorderClr,
    this.borderRadius,
    this.textHeight,
    this.contentPadding,
    this.enabled,
    this.isObscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 48.h,
      width: width,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: color ?? HexColor('#1F2937'),
        border: Border.all(
          color: borderColor ?? HexColor('#6B7280'),
          width: 1.sp,
        ),
        borderRadius: BorderRadius.circular(borderRadius ?? 8.sp),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: textInputType == TextInputType.number ? 0.0 : 4.0,
        ),
        child: Align(
          alignment: Alignment.center,
          child: TextFormField(
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            // TextCapitalization.sentences,
            scrollPadding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            textAlignVertical: textAlignVertical ?? TextAlignVertical.center,
            autofocus: autoFocus,
            inputFormatters: inputFormatters,
            textInputAction: textInputAction,
            validator: validator,
            onTap: onTap,
            obscureText: isObscureText ?? passwordVisible,
            maxLength: maxLength,
            controller: controller,
            focusNode: focusNode,
            onFieldSubmitted: onFieldSubmitted,
            initialValue: initialValue,
            readOnly: readOnly ?? false,
            enabled: enabled ?? true,
            maxLines: maxLines,
            minLines: minLines ?? 1,
            textAlign: textAlign ?? TextAlign.start,
            keyboardType: textInputType,
            keyboardAppearance: Brightness.dark,
            expands: expands,
            // cursorHeight: 20,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize ?? 16.sp,
              overflow: TextOverflow.visible,
              fontFamily: fontFamilyText ?? strFontName,
              fontWeight: fontWeightText ?? FontWeight.w600,
              height: textHeight,
            ),
            cursorColor: colorPrimary,
            onChanged: onChanged,
            onEditingComplete: onEditingComplete,
            decoration: InputDecoration(
              enabled: true,
              // alignLabelWithHint: true,
              counterText: counterText ?? "",
              isDense: true,
              prefixIcon:
                  prefixIcon != null
                      ? Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          top: 10,
                          bottom: 6,
                          right: 4,
                        ),
                        child: SvgPicture.asset(
                          prefixIcon!,
                          height: 12.h,
                          width: 12.w,
                          fit: BoxFit.contain,
                          colorFilter:
                              focusColor != null
                                  ? ColorFilter.mode(
                                    colorPrimary,
                                    BlendMode.srcIn,
                                  )
                                  : null,
                        ),
                      )
                      : prefix,
              prefixIconConstraints: BoxConstraints(
                minWidth: 36, // Adjust as needed
                minHeight: 30,
              ),
              focusColor: Colors.black12,
              suffixText: suffixText,
              suffix: suffix,
              labelStyle: TextStyle(
                color: colorWhite.withOpacity(0.5),
                fontFamily: strFontName,
                fontSize: 14.sp,
                fontWeight: FontWeight.w300,
              ),
              border: InputBorder.none,
              /*  border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 10.sp),
                borderSide: BorderSide(color: focusColor ?? colorDCDCDC, width: 1.sp),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 10.sp),
                borderSide: BorderSide(color: focusColor ?? colorDCDCDC, width: 1.sp),
              ),
              focusedBorder: OutlineInputBorder(
                gapPadding: 0.0,
                borderRadius: BorderRadius.circular(borderRadius ?? 10.sp),
                borderSide: BorderSide(color: focusColor ?? colorDCDCDC, width: 1.sp),
              ),*/
              // label: label != null
              //     ? null
              //     : Text(
              //         hint ?? "",
              //         style: TextStyle(
              //           color: hintColor ?? colorBDB5D2,
              //           fontSize: 14.sp,
              //           fontFamily: fontFamilyHint ?? strFontName,
              //           fontWeight: fontWeightHint ?? FontWeight.w500,
              //         ),
              //       ),
              hintText: hint,
              suffixStyle: TextStyle(
                color: colorWhite,
                fontSize: suffixFontSize ?? 16.sp,
                fontFamily: suffixFontFamilyText ?? strFontName,
                fontWeight: suffixFontWeightText ?? FontWeight.w500,
              ),
              suffixIcon:
                  suffixIconWidget ??
                  (suffixIconName != null
                      ? GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onTapSuffixIcon,
                        child: Padding(
                          padding: EdgeInsets.all(8.sp),
                          child: SvgPicture.asset(
                            suffixIconName!,
                            width: suffixIconWidth ?? 24.sp,
                            height: suffixIconHeight ?? 24.sp,
                            fit: BoxFit.scaleDown,
                            colorFilter:
                                focusColor != null
                                    ? ColorFilter.mode(
                                      colorPrimary,
                                      BlendMode.srcIn,
                                    )
                                    : null,
                          ),
                        ),
                      )
                      : null),
              // hintText: hint,
              // contentPadding: EdgeInsets.symmetric(
              //   vertical: verticalContentPadding ?? 16.h,
              // ),
              hintStyle: TextStyle(
                color: hintColor ?? HexColor('#6B7280'),
                fontSize: 12.sp,
                fontFamily: fontFamilyHint ?? strFontName,
                fontWeight: fontWeightHint ?? FontWeight.w500,
              ),
              filled: true,
              fillColor: Colors.transparent,
              // border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
