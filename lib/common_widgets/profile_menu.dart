import 'package:OneBrain/controllers/profile_menu_controller.dart';
import 'package:OneBrain/models/plan_user_model.dart';
import 'package:OneBrain/services/profile_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel? user = ProfileService.user;
    return InkWell(
      splashColor: Colors.transparent,

      onTap: () {
        Get.find<ProfileMenuController>().toggleProfileMenu(context);
      },
      child: Container(
        width: 30.sp,
        height: 30.sp,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Color(0xFF60A6F9), // your border color
            width: 2, // adjust thickness
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: user?.profileImage?.trim() ?? '',
            fit: BoxFit.cover,
            errorWidget: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.purple.shade600],
                  ),
                ),
                child: Center(
                  child: Text(
                    user?.getFullName.substring(0, 1) ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              );
            },
            progressIndicatorBuilder: (context, child, loadingProgress) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.purple.shade600],
                  ),
                ),
                child: Center(
                  child: Text(
                    user?.getFullName.substring(0, 1) ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
