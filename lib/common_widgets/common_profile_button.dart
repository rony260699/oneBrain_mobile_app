import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../resources/color.dart';
import '../resources/image.dart';
import '../resources/strings.dart';
import 'common_widgets.dart';
import 'text_widget.dart';

class ProfileWidget extends StatelessWidget {
  final String? textName;
  final String? iconName;
  final GestureTapCallback? onTap;
  final bool isArrow;
  final Widget? endWidget;

  const ProfileWidget({super.key, this.textName, this.iconName, this.onTap, this.isArrow = true, this.endWidget});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14.r), border: Border.all(color: colorDFE9F0)),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 17.h),
        child: Row(
          children: [
            SvgPicture.asset(
              iconName ?? '',
              height: 26.sp,
              width: 26.sp,
              fit: BoxFit.scaleDown,
            ),
            widthBox(12.w),
            TextWidget(
              text: textName,
              fontWeight: FontWeight.w400,
              fontSize: 15.sp,
              fontFamily: strFontName,
            ),
            const Spacer(),
            isArrow
                ? SvgPicture.asset(
                    SVGImg.rightArrowIcon,
                    height: 18.sp,
                    width: 18.sp,
                    fit: BoxFit.scaleDown,
                  )
                : const SizedBox(),
            endWidget ?? SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
