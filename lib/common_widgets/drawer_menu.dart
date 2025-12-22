import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key, required this.onTap});

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 6.0),
        child: SvgPicture.asset(
          "assets/icons/logo.svg",
          height: 30.sp,
          width: 30.sp,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
