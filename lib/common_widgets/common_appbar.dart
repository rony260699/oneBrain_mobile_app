import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../common_widgets/text_widget.dart';
import '../resources/color.dart';
import '../resources/image.dart';
import '../resources/strings.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? leadingIcon;
  final Widget? iconImage;
  final String? prefixTextName, prefixIcon;
  final bool? shouldShowBackButton;
  final bool? showLogoTitle;
  final PreferredSizeWidget? bottom;
  final bool? isPrefixIcon;
  final Widget? leading;
  final Widget? prefixWidget;
  final bool automaticallyImplyLeading;
  final GestureTapCallback? onTapPrefix;
  final GestureTapCallback? onPressBack;
  final Color? statusBarColor, backgroundColor, textColor, backArrowColor;
  final GestureTapCallback? onTapAction;
  final double? toolbarHeight, titleSpacing;
  final Brightness? statusBarIconBrightness;
  final Brightness? statusBarBrightness;
  final bool? centerTitle;
  final Widget? flexibleSpace;
  final Widget? titleWidget;
  final ColorFilter? leadingIcnColor;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;

  const CommonAppBar({
    super.key,
    this.title,
    this.leadingIcon,
    this.shouldShowBackButton = true,
    this.showLogoTitle = false,
    this.bottom,
    this.isPrefixIcon,
    this.prefixIcon,
    this.prefixTextName,
    this.toolbarHeight,
    this.onTapPrefix,
    this.iconImage,
    this.onPressBack,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.statusBarColor,
    this.prefixWidget,
    this.backgroundColor,
    this.textColor,
    this.backArrowColor,
    this.onTapAction,
    this.statusBarBrightness,
    this.centerTitle = true,
    this.flexibleSpace,
    this.titleSpacing,
    this.statusBarIconBrightness,
    this.titleWidget,
    this.leadingIcnColor,
    this.titleFontSize,
    this.titleFontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: colorTransparent,
        statusBarBrightness: statusBarBrightness ?? Brightness.dark,
        statusBarIconBrightness: statusBarIconBrightness ?? Brightness.light,
      ),
      backgroundColor: backgroundColor ?? colorWhite,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: automaticallyImplyLeading,
      toolbarHeight: toolbarHeight ?? 56.h,
      title:
          titleWidget ??
          Padding(
            padding: const EdgeInsets.only(bottom: 1.0),
            child:
                iconImage ??
                TextWidget(
                  text: title ?? '',
                  color: textColor ?? color170B37,
                  fontSize: titleFontSize ?? 20.sp,
                  fontWeight: titleFontWeight ?? FontWeight.w700,
                  fontFamily: strFontName,
                  textAlign: TextAlign.center,
                  textHeight: 1.8.sp,
                ),
          ),
      titleSpacing: titleSpacing ?? 0,
      centerTitle: centerTitle,
      leading:
          (shouldShowBackButton ?? true)
              ? leading ??
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap:
                        onPressBack ??
                        () {
                          if (Navigator.canPop(context)) Navigator.pop(context);
                        },
                    child: Container(
                      height: 40.h,
                      width: 40.w,
                      margin: const EdgeInsets.only(left: 20),
                      padding: const EdgeInsets.only(right: 7),
                      child: SvgPicture.asset(
                        leadingIcon ?? SVGImg.icBack,
                        height: 42.h,
                        width: 42.w,
                      ),
                    ),
                  )
              : Container(),
      leadingWidth: 66.sp,
      actions: [
        prefixTextName != null
            ? Container(
              margin: EdgeInsets.only(right: 15.w),
              padding: const EdgeInsets.only(right: 5, left: 5, top: 0),
              child: TextWidget(
                text: prefixTextName,
                fontSize: 14.sp,
                color: colorA59BBF,
                fontWeight: FontWeight.w500,
                onTap: onTapAction,
              ),
            )
            : prefixIcon != null
            ? GestureDetector(
              onTap: onTapAction,
              child: Container(
                margin: EdgeInsets.only(right: 12.w, bottom: 5),
                child: SvgPicture.asset(
                  prefixIcon!,
                  width: 42.w,
                  height: 42.h,
                  fit: BoxFit.scaleDown,
                ),
              ),
            )
            : prefixWidget ?? const SizedBox.shrink(),
      ],
      bottom: bottom,
      flexibleSpace: flexibleSpace,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? 50.h);
}