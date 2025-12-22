import 'package:OneBrain/common_widgets/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../base/base_stateful_state.dart';
import '../../../common_widgets/text_widget.dart';
import '../../../resources/strings.dart';

class ModelListView extends StatelessWidget {
  const ModelListView({
    super.key,
    required this.provider,
    required this.isActive,
    required this.image,
    required this.description,
  });

  final String provider;
  final bool isActive;
  final String image;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isActive ? HexColor('#1E293B') : Colors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            // border: GradientBoxBorder(
            //   gradient: LinearGradient(
            //     colors: [
            //       HexColor('#A855F7'),
            //       HexColor('#3B82F6'),
            //       HexColor('#06B6D4'),
            //     ],
            //     begin: Alignment.centerLeft,
            //     end: Alignment.centerRight,
            //   ),
            //   width: 2,
            // ),
            color: isActive ? HexColor('#1D283B') : HexColor('#1D283A'),
            border: Border.all(
              color: isActive ? HexColor('#3275f4') : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              // Subtle glow effect only - 5% opacity
              BoxShadow(
                color: HexColor('#3B82F6').withValues(alpha: 0.05),
                blurRadius: 20,
                offset: Offset(0, 0),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: HexColor('#A855F7').withValues(alpha: 0.05),
                blurRadius: 15,
                offset: Offset(0, 0),
                spreadRadius: 0,
              ),
            ],
          ),
          // : BoxDecoration(
          //   borderRadius: BorderRadius.circular(20),
          //   border: Border.all(
          //     color: Colors.white,
          //     width: 2,
          //   ),
          // ),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: [
                // AI Model Icon with clean styling
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: SvgPicture.asset(image),
                  ),
                ),

                SizedBox(width: 20),

                // Model details with better text handling
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextWidget(
                              text: provider.capitalizeFirst,
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: strFontName,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 12),

                          // Simple clean toggle switch
                          Container(
                            width: 50,
                            height: 28,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color:
                                  isActive
                                      ? HexColor('#3B82F6')
                                      : HexColor('#1C2432'),
                              border: Border.all(
                                color:
                                    isActive
                                        ? HexColor('#3B82F6')
                                        : HexColor('#4B5463'),
                                width: 2,
                              ),
                            ),
                            child: AnimatedAlign(
                              duration: Duration(milliseconds: 200),
                              alignment:
                                  isActive
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              child: Container(
                                width: 22,
                                height: 22,
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      isActive
                                          ? Colors.white
                                          : HexColor('#9BA2AF'),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 3,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8),

                      // Compact description with proper text handling
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: 40, // Fixed height to prevent overflow
                        ),
                        child: TextWidget(
                          text: description,
                          fontSize: 13,
                          color: HexColor('#F8F8F8'),
                          fontFamily: strFontName,
                          fontWeight: FontWeight.w600,
                          maxLines: 2,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
