import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class NewChatMenu extends StatelessWidget {
  const NewChatMenu({super.key, required this.onTap});

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        width: 30.sp,
        height: 30.sp,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: Center(
          child: SvgPicture.asset(
            "assets/icons/new_chat.svg",
            height: 16.sp,
            width: 16.sp,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ),
    );
  }
}
