import 'package:OneBrain/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common_widgets/text_widget.dart';
import '../../../resources/image.dart';

class FeaturesListView extends StatefulWidget {
  final String title;
  const FeaturesListView({super.key, required this.title});

  @override
  State<FeaturesListView> createState() => _FeaturesListViewState();
}

class _FeaturesListViewState extends State<FeaturesListView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          SvgPicture.asset(
            SVGImg.checkIcon,
            height: 20.sp,
            width: 20.sp,
            fit: BoxFit.scaleDown,
          ),
          widthBox(6),
          Flexible(
            child: TextWidget(
              text: widget.title,
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
