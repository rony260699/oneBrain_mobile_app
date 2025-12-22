import 'dart:math' as math;

import 'package:OneBrain/base/base_stateful_state.dart';
import 'package:OneBrain/common_widgets/app_utils.dart';
import 'package:OneBrain/common_widgets/common_widgets.dart';
import 'package:OneBrain/models/ai_model.dart';
import 'package:OneBrain/resources/image.dart';
import 'package:OneBrain/resources/strings.dart';
import 'package:OneBrain/screens/payment_billing/payment_page.dart';
import 'package:OneBrain/services/ai_model_service.dart';
import 'package:OneBrain/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../common_widgets/text_widget.dart';

class AIPopupListView extends StatefulWidget {
  final AIModel? selectedModel;
  final Function(String)? onProviderSelected;
  final Function(AIModel)? onModelSelected;
  final String aiModelImage;
  final String provider;
  final bool isExpanded;

  const AIPopupListView({
    super.key,
    required this.selectedModel,
    required this.aiModelImage,
    required this.onModelSelected,
    required this.provider,
    required this.isExpanded,
    required this.onProviderSelected,
  });

  @override
  State<AIPopupListView> createState() => _AIPopupListViewState();
}

class _AIPopupListViewState extends State<AIPopupListView> {
  @override
  Widget build(BuildContext context) {
    List<AIModel> models = AIModelService.getProviderModels(
      widget.provider,
      ProfileService.user!,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 34,
            decoration: BoxDecoration(
              color:
                  widget.selectedModel?.provider == widget.provider
                      ? HexColor('#495083').withValues(alpha: 0.3)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (widget.provider != "max") {
                  widget.onProviderSelected?.call(widget.provider);
                } else {
                  if (models.firstOrNull?.isLocked ?? false) {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentPage()),
                    );
                  } else {
                    widget.onModelSelected?.call(models.first);
                  }
                }
                HapticFeedback.selectionClick();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 4,
                            top: 2,
                            bottom: 2,
                          ),
                          child: SvgPicture.asset(
                            widget.aiModelImage,
                            height: 22,
                            width: 22,
                          ),
                        ),
                        widthBox(4),
                        TextWidget(
                          text: widget.provider.capitalizeFirst,
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontFamily: strFontName,
                          fontWeight: FontWeight.w700,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  if (widget.provider != "max")
                    Container(
                      width: 44, // Larger tap area
                      height: 34, // Match container height
                      padding: const EdgeInsets.all(8.0),
                      child: Transform.rotate(
                        angle:
                            widget.isExpanded
                                ? -math.pi
                                : 0, // Fixed rotation angle
                        child: Image.asset(
                          PNGImages.downArrow,
                          height: 18,
                          color: Colors.white,
                        ),
                      ),
                    )
                  else if (models.firstOrNull?.isLocked ?? false)
                    SizedBox(
                      width: 44,
                      height: 34,
                      child: Center(
                        child: TextWidget(
                          text: "🔒",
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontFamily: strFontName,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  else
                    widget.selectedModel?.name == models.firstOrNull?.name
                        ? SizedBox(
                          width: 44,
                          height: 34,
                          child: Center(
                            child: Image.asset(
                              PNGImages.checkSelected,
                              height: 14,
                            ),
                          ),
                        )
                        : Container(),
                ],
              ),
            ),
          ),
          widget.isExpanded
              ? Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: ListView.builder(
                  itemCount: models.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    final model = models[index];
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        // if (availableTokens <= 0 &&
                        //     !(model.name?.contains("Unlimited") ?? false)) {

                        if (model.isLocked ?? false) {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(),
                            ),
                          );
                        } else {
                          widget.onModelSelected?.call(model);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 40,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                index ==
                                        (AIModelService.allAIModels?.length ??
                                            0 - 1)
                                    ? Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 6.0,
                                      ),
                                      child: Container(
                                        color: Color(0xFFB0B7F2),
                                        width: 2,
                                      ),
                                    )
                                    : Container(
                                      color: Color(0xFFB0B7F2),
                                      width: 2,
                                    ),
                                Image.asset(
                                  PNGImages.lineImg2,
                                  width: 12,
                                  height: 36,
                                  fit: BoxFit.fill,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    top: 20,
                                  ),
                                  child: TextWidget(
                                    text: "${model.name}",
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                    fontFamily: strFontName,
                                    fontWeight: FontWeight.w500,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // (availableTokens <= 0 &&
                          //         !(model.name?.contains("Unlimited") ?? false))
                          (model.isLocked ?? false)
                              ? SizedBox(
                                width: 44,
                                height: 34,
                                child: Center(
                                  child: TextWidget(
                                    text: "🔒",
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontFamily: strFontName,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                              : widget.selectedModel?.name == model.name
                              ? SizedBox(
                                width: 44, // Larger tap area
                                height: 34, // Match container height
                                child: Center(
                                  child: Image.asset(
                                    PNGImages.checkSelected,
                                    height: 14,
                                  ),
                                ),
                              )
                              : SizedBox(),
                        ],
                      ),
                    );
                  },
                ),
              )
              : Container(),
        ],
      ),
    );
  }
}

class CurvedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Color(0xFFB0B7F2) // Replace with your actual color
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

    final path =
        Path()
          ..moveTo(0, 0)
          ..lineTo(0, size.height - 20)
          ..quadraticBezierTo(0, size.height, 20, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
