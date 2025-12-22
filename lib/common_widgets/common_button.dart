import 'package:OneBrain/base/base_stateful_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/color.dart';
import '../resources/strings.dart';
import 'bounce_button.dart';
import 'common_widgets.dart';
import 'text_widget.dart';

class CommonButton extends StatefulWidget {
  final double? width, height;
  final double? lineWidth, lineHeight, totalHeight;
  final double? borderRadius;
  final String? text;
  final String? stringAssetName;
  final GestureTapCallback? onTap;
  final bool showLoading;
  final bool isIcon;
  final bool isTrailingIcon;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? assetHeight;
  final double? assetWidth;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? buttonPadHorizon;
  final double? buttonPadVertical;
  final double borderWidth;
  final Widget? iconWidget;
  final EdgeInsetsGeometry? buttonMargin;
  final Gradient? gradientColor;
  final List<BoxShadow>? boxShadow;
  final Color? boxShadowColor;
  final bool isShadowShow;
  final bool isSmallButton;
  final bool isBgBtn;

  const CommonButton({
    super.key,
    this.width,
    this.borderRadius,
    this.height,
    this.lineWidth,
    this.lineHeight,
    this.totalHeight,
    this.text,
    this.onTap,
    this.showLoading = false,
    this.textColor,
    this.verticalPadding,
    this.stringAssetName,
    this.isIcon = false,
    this.assetWidth,
    this.assetHeight,
    this.fontSize,
    this.fontWeight,
    this.horizontalPadding,
    this.borderColor,
    this.backgroundColor,
    this.borderWidth = 1.0,
    this.iconWidget,
    this.buttonMargin,
    this.gradientColor,
    this.boxShadow,
    this.buttonPadHorizon,
    this.buttonPadVertical,
    this.isTrailingIcon = false,
    this.boxShadowColor,
    this.isShadowShow = false,
    this.isSmallButton = false,
    this.isBgBtn = false,
  });

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    return BounceButton(
      onTap: widget.showLoading ? null : widget.onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.buttonPadHorizon ?? 0.w,
          vertical: widget.buttonPadVertical ?? 0.h,
        ),
        child: Container(
          width: widget.width ?? MediaQuery.of(context).size.width,
          height: widget.height ?? 57.h,
          margin: widget.buttonMargin,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? HexColor('#3B4484'),
            gradient:
                widget.gradientColor ??
                LinearGradient(
                  colors: [HexColor('#00008B'), HexColor('#656FE2')],
                  begin: const FractionalOffset(0.0, 0.0),
                  end:
                      widget.isBgBtn
                          ? const FractionalOffset(0.0, 1)
                          : const FractionalOffset(1.0, 0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 20.r),
            border: Border.all(
              color: widget.borderColor ?? HexColor('#656FE2'),
              width: widget.borderWidth,
            ),
            boxShadow:
                widget.isShadowShow
                    ? [
                      BoxShadow(
                        offset: Offset(0, 6),
                        blurRadius: 6,
                        color:
                            widget.boxShadowColor ??
                            colorPrimary.withOpacity(.2),
                      ),
                    ]
                    : [],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: widget.verticalPadding ?? 0.h,
              horizontal: widget.horizontalPadding ?? 12.0,
            ),
            child: Center(
              child:
                  widget.showLoading
                      ? commonLoader(
                        color: Colors.white,
                        size: !widget.isSmallButton ? 26.h : 18.h,
                      )
                      : widget.isIcon
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.isTrailingIcon
                              ? Container()
                              : Row(
                                children: [
                                  widthBox(8.w),
                                  Image.asset(
                                    widget.stringAssetName!,
                                    height: widget.assetHeight,
                                    width: widget.assetWidth,
                                  ),
                                ],
                              ),
                          TextWidget(
                            text: widget.text ?? '',
                            fontSize: widget.fontSize ?? 16.sp,
                            fontWeight: widget.fontWeight ?? FontWeight.w700,
                            fontFamily: strFontName,
                            color: widget.textColor ?? colorWhite,
                          ),
                          Row(
                            children: [
                              widthBox(8.w),
                              widget.isTrailingIcon == false
                                  ? Container()
                                  : Image.asset(
                                    widget.stringAssetName!,
                                    height: widget.assetHeight,
                                    width: widget.assetWidth,
                                  ),
                            ],
                          ),
                        ],
                      )
                      : SizedBox(
                        height: widget.totalHeight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.w),
                          child: TextWidget(
                            text: widget.text ?? '',
                            fontSize: widget.fontSize ?? 16.sp,
                            fontWeight: widget.fontWeight ?? FontWeight.w400,
                            fontFamily: strFontName,
                            color: widget.textColor ?? colorWhite,
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
