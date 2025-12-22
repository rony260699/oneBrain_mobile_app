import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../resources/color.dart';
import '../resources/image.dart';
import 'common_button.dart';
import 'text_widget.dart';

class CustomDialog extends StatelessWidget {
  final String? content;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onTapClose;
  final bool? showCloseIcon;

  const CustomDialog({super.key, required this.content, this.onTap, this.onTapClose, this.showCloseIcon = true});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 25.0,
      ),
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            // color: colorPrimary.withOpacity(.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  PNGImages.appLogo,
                  height: 80.sp,
                  width: 80.sp,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: TextWidget(
                  text: content,
                  color: colorBlack,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CommonButton(
                text: 'Go it',
                width: MediaQuery.of(context).size.width * 0.3,
                verticalPadding: 12,
                onTap: onTap,
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

