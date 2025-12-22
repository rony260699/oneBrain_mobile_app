// import 'package:OneBrain/common_widgets/common_button.dart';
// import 'package:OneBrain/common_widgets/common_widgets.dart';
// import 'package:OneBrain/resources/image.dart';
// import 'package:OneBrain/resources/strings.dart';
// import 'package:OneBrain/screens/payment_billing/view/features_list_view.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../base/base_stateful_state.dart';
// import '../../../common_widgets/text_widget.dart';
// import '../model/plan_list_model.dart';

// class PlanListView extends StatefulWidget {
//   final PlanListModel currentPlan;
//   const PlanListView({super.key, required this.currentPlan});

//   @override
//     State<PlanListView> createState() => _PlanListViewState();
// }

// class _PlanListViewState extends State<PlanListView> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//       child: Stack(
//         children: [
//           widget.currentPlan.planMainPrice == 0
//               ? Container()
//               : Positioned(
//                 top: -40,
//                 right: -20,
//                 child: Container(
//                   height: 127,
//                   width: 118,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage(PNGImages.discountView),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 50.0, left: 0),
//                     child: TextWidget(
//                       text:
//                           "Save\n${widget.currentPlan.planCurrencySymbol}${(widget.currentPlan.planMainPrice - widget.currentPlan.planPrice).toInt().toString()}${widget.currentPlan.planCurrency}",
//                       fontSize: 16.sp,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w400,
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//               ),
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   HexColor('#A855F7').withValues(alpha: 0.1),
//                   HexColor('#3B82F6').withValues(alpha: 0.1),
//                   HexColor('#06B6D4').withValues(alpha: 0.1),
//                 ],
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//                 tileMode: TileMode.clamp,
//               ),
//               border: Border.all(color: HexColor('#656FE2'), width: 1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12, bottom: 12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextWidget(
//                     text: widget.currentPlan.planName,
//                     fontSize: 18.sp,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w500,
//                     textAlign: TextAlign.center,
//                   ),
//                   TextWidget(
//                     text: widget.currentPlan.planType,
//                     fontSize: 12.sp,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w400,
//                     textAlign: TextAlign.center,
//                   ),
//                   heightBox(16),
//                   Row(
//                     children: [
//                       TextWidget(
//                         text: widget.currentPlan.planFullPrice,
//                         textStyle: TextStyle(
//                           color: HexColor('#FAFAFA'),
//                           fontFamily: strFontName,
//                           fontSize: 20.sp,
//                           shadows: <Shadow>[
//                             Shadow(offset: Offset(2.0, 2.0), blurRadius: 10.0, color: Colors.black),
//                           ],
//                         ),
//                         fontWeight: FontWeight.w500,
//                         textAlign: TextAlign.center,
//                       ),
//                       widget.currentPlan.planMainPrice == 0
//                           ? Container()
//                           : Row(
//                             children: [
//                               widthBox(12),
//                               TextWidget(
//                                 text:
//                                     "${widget.currentPlan.planCurrencySymbol}${widget.currentPlan.planMainPrice.toString()}${widget.currentPlan.planCurrency}",
//                                 color: HexColor('#A1A1AA'),
//                                 textStyle: TextStyle(
//                                   color: HexColor('#A1A1AA'),
//                                   decoration: TextDecoration.lineThrough,
//                                   decorationColor: HexColor('#A1A1AA'),
//                                   fontFamily: strFontName,
//                                   fontSize: 16.sp,
//                                 ),
//                                 fontWeight: FontWeight.w500,
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                       widthBox(12),
//                       TextWidget(
//                         text: "/${widget.currentPlan.planLength}",
//                         fontSize: 12.sp,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w400,
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                   heightBox(16),
//                   TextWidget(
//                     text: "Free Features",
//                     fontSize: 16.sp,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                     textAlign: TextAlign.center,
//                   ),
//                   heightBox(10),
//                   ListView.builder(
//                     itemCount: widget.currentPlan.arrOfFeatures.length,
//                     shrinkWrap: true,
//                     padding: EdgeInsets.zero,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemBuilder: (content, index) {
//                       return FeaturesListView(title: widget.currentPlan.arrOfFeatures[index]);
//                     },
//                   ),
//                   heightBox(10),
//                   widget.currentPlan.isCurrent
//                       ? Padding(
//                         padding: const EdgeInsets.only(left: 12.0),
//                         child: Column(
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 TextWidget(
//                                   text: "Token Balance",
//                                   fontSize: 18.sp,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w600,
//                                   textAlign: TextAlign.left,
//                                 ),
//                                 heightBox(4),
//                                 TextWidget(
//                                   text: "Your available tokens for accessing premium features.",
//                                   fontSize: 14.sp,
//                                   color: Colors.white,
//                                   textHeight: 1.8,
//                                   fontWeight: FontWeight.w400,
//                                   textAlign: TextAlign.left,
//                                 ),
//                               ],
//                             ),
//                             heightBox(10),
//                           ],
//                         ),
//                       )
//                       : Container(),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: CommonButton(
//                       text: widget.currentPlan.buyButtonText,
//                       height: 44,
//                       textColor:
//                           widget.currentPlan.isCurrent ? HexColor('#F8FAFC') : HexColor('#18181B'),
//                       borderRadius: 6,
//                       gradientColor: LinearGradient(
//                         colors:
//                             widget.currentPlan.isCurrent
//                                 ? [
//                                   HexColor('#A855F7').withValues(alpha: 0.2),
//                                   HexColor('#3B82F6').withValues(alpha: 0.2),
//                                   HexColor('#06B6D4').withValues(alpha: 0.2),
//                                 ]
//                                 : [Colors.white],
//                         begin: const FractionalOffset(0.0, 0.0),
//                         end: const FractionalOffset(1.0, 0),
//                         stops: widget.currentPlan.isCurrent ? [0.0, 0.5, 1.0] : [0.0],
//                         tileMode: TileMode.clamp,
//                       ),
//                       borderWidth: 1,
//                       borderColor: HexColor('#FAFAFA'),
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
