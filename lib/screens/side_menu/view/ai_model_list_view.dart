// import 'dart:ffi'; // Removed for web compatibility
import 'package:OneBrain/base/base_stateful_state.dart';
import 'package:OneBrain/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import '../../../common_widgets/text_widget.dart';
import '../model/ai_list_model.dart';

class AiModelListView extends StatefulWidget {
  final AiModelListing currentAiModel;
  const AiModelListView({super.key, required this.currentAiModel});

  @override
  State<AiModelListView> createState() => _AiModelListViewState();
}

class _AiModelListViewState extends State<AiModelListView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12.0,
        right: 12.0,
        top: 4,
        bottom: 4,
      ),
      child: Container(
        height: 44,
        width: 200,
        decoration: BoxDecoration(
          color:
              widget.currentAiModel.isSelected
                  ? HexColor('#111827')
                  : Colors.transparent,
          border:
              widget.currentAiModel.isSelected
                  ? GradientBoxBorder(
                    gradient: LinearGradient(
                      colors: [
                        HexColor('#A855F7').withValues(alpha: 0.5),
                        HexColor('#3B82F6').withValues(alpha: 0.5),
                        HexColor('#06B6D4').withValues(alpha: 0.5),
                      ],
                    ),
                    width: 1,
                  )
                  : Border(),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 4,
                top: 8,
                bottom: 8,
              ),
              child: Image.asset(
                widget.currentAiModel.aiModelImage,
                height: 20,
                width: 20,
              ),
            ),
            widthBox(8),
            TextWidget(
              text: widget.currentAiModel.aiName,
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
