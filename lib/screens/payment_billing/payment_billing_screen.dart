// import 'package:OneBrain/base/base_stateful_state.dart';
// import 'package:OneBrain/common_widgets/common_widgets.dart';
// import 'package:OneBrain/screens/payment_billing/payment_history_screen.dart';
// import 'package:OneBrain/screens/payment_billing/view/plan_list_view.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:simple_gradient_text/simple_gradient_text.dart';
// import '../../common_widgets/common_appbar.dart';
// import '../../common_widgets/text_widget.dart';
// import '../../resources/image.dart';
// import '../../resources/strings.dart';
// import 'cubit/payment_cubit.dart';
// import 'cubit/payment_state.dart';
// import 'model/plan_list_model.dart';

// class PaymentBillingScreen extends StatefulWidget {
//   const PaymentBillingScreen({super.key});

//   @override
//   State<PaymentBillingScreen> createState() => _PaymentBillingScreenState();
// }

// class _PaymentBillingScreenState
//     extends BaseStatefulWidgetState<PaymentBillingScreen> {
//   late int selectedIndex = 0;

//   // late List<PlanListModel> arrOfPlanLists = [];
//   // late List<PlanListModel> arrOfTopUpLists = [];
//   late PlanListModel currentPlan;

//   @override
//   void initState() {
//     shouldHaveSafeArea = true; // Enable safe area to avoid navigation buttons
//     extendBodyBehindAppBar = true;
//     resizeToAvoidBottomInset = false;
//     // initPlans();
//     // initTopUps();
//     super.initState();
//   }

//   void initPlans() {
//     arrOfPlanLists.add(
//       PlanListModel(
//         "Basic 🔹",
//         "Best for Students & Beginners",
//         299,
//         "TK",
//         "৳",
//         "Free Features",
//         [
//           "6,00,000 Pro Tokens",
//           "Access to all AI Models",
//           "Unlimited Chat & Attachments",
//           "DeepSearch & Reasoning Features",
//           "DeepSearch & Reasoning Features",
//           "Early access to new features",
//         ],
//         0,
//         "৳299TK",
//         "1 Month",
//         false,
//         "Buy",
//       ),
//     );
//     arrOfPlanLists.add(
//       PlanListModel(
//         "Pro 🔥",
//         "Frequent Users & Small Businesses",
//         1599,
//         "TK",
//         "৳",
//         "Pro Features",
//         [
//           "38,00,000 Pro Tokens (^5.56% Increased)",
//           "Access to all AI Models",
//           "Unlimited Chat & Attachments",
//           "DeepSearch & Reasoning Features",
//           "Priority support from technical team",
//           "Early access to new features",
//         ],
//         1794,
//         "৳1,599TK",
//         "6 Months",
//         false,
//         "Buy",
//       ),
//     );
//     arrOfPlanLists.add(
//       PlanListModel(
//         "Premium 💎",
//         "Power Users & Enterprises",
//         3399,
//         "TK",
//         "৳",
//         "Premium Features",
//         [
//           "80,00,000 Pro Tokens (^11.11% Increased)",
//           "Access to all AI Models",
//           "Unlimited Chat & Attachments",
//           "DeepSearch & Reasoning Features",
//           "Priority support from technical team",
//           "Early access to new features",
//         ],
//         3688,
//         "৳3,399TK",
//         "1 Year",
//         false,
//         "Buy",
//       ),
//     );
//     currentPlan = PlanListModel(
//       "Free 🦾",
//       "For All Users",
//       0,
//       "TK",
//       "৳",
//       "Basic Features",
//       ["15 conversations per day", "Basic AI models", "Standard support"],
//       0,
//       "৳0TK",
//       "Free",
//       true,
//       "10000 Pro tokens left",
//     );
//     setState(() {});
//   }

//   void initTopUps() {
//     arrOfTopUpLists.add(
//       PlanListModel(
//         "Economy",
//         "Quick & affordable",
//         149,
//         "TK",
//         "৳",
//         "You will receive",
//         ["3,00,000 Pro Tokens", "Unlimited Chat Extended"],
//         0,
//         "৳299TK",
//         "15 days",
//         false,
//         "Buy",
//       ),
//     );
//     arrOfTopUpLists.add(
//       PlanListModel(
//         "Advance",
//         "Bulk loaded",
//         249,
//         "TK",
//         "৳",
//         "You will receive",
//         ["6,00,000 Pro Tokens", "Unlimited Chat Extended"],
//         0,
//         "৳249TK",
//         "15 days",
//         false,
//         "Buy",
//       ),
//     );
//     arrOfTopUpLists.add(
//       PlanListModel(
//         "Advance",
//         "Bulk loaded",
//         349,
//         "TK",
//         "৳",
//         "You will receive",
//         ["9,00,000 Pro Tokens", "Up to 150 Image Generation"],
//         0,
//         "৳349TK",
//         "30 days",
//         false,
//         "Buy",
//       ),
//     );
//     arrOfTopUpLists.add(
//       PlanListModel(
//         "Cracker",
//         "Tech-savvy",
//         499,
//         "TK",
//         "৳",
//         "You will receive",
//         ["12,00,000 Pro Tokens", "Unlimited Chat Extended"],
//         0,
//         "৳499TK",
//         "30 days",
//         false,
//         "Buy",
//       ),
//     );
//     setState(() {});
//   }

//   @override
//   PreferredSizeWidget? buildAppBar(BuildContext context) {
//     return CommonAppBar(
//       backgroundColor: Colors.transparent,
//       centerTitle: true,
//       shouldShowBackButton: true,
//       titleWidget: GradientText(
//         'Billing & Plans',
//         colors: [HexColor('#BA87FC'), HexColor('#6BA2FB')],
//         style: const TextStyle(
//           fontSize: 28,
//           fontFamily: strFontName,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//       prefixWidget: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Payment history button
//           Padding(
//             padding: const EdgeInsets.only(right: 16.0),
//             child: InkWell(
//               splashColor: Colors.transparent,
//               onTap: () {
//                 push(context, enterPage: PaymentHistoryScreen());
//               },
//               child: SvgPicture.asset(
//                 SVGImg.historyIcon,
//                 height: 30.sp,
//                 width: 30.sp,
//                 fit: BoxFit.scaleDown,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget buildBody(BuildContext context) {
//     return BlocListener<PaymentCubit, PaymentStates>(
//       listener: (context, state) {},
//       child: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF000000), // Pure black at top for better text visibility
//               Color(0xFF000000), // Keep black longer for content area
//               Color(0xFF0A0E24), // Deep dark blue starts lower
//               Color(0xFF0C1028), // Slightly lighter dark blue at bottom
//             ],
//             stops: [0.0, 0.7, 0.85, 1.0], // Push blue colors towards bottom
//           ),
//         ),
//         child: SafeArea(
//           bottom: false,
//           child: Padding(
//             padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 8),
//             child: Column(
//               children: [
//                 Center(
//                   child: Stack(
//                     textDirection:
//                         selectedIndex == 1
//                             ? TextDirection.rtl
//                             : TextDirection.ltr,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           setState(() {
//                             selectedIndex = selectedIndex == 1 ? 0 : 1;
//                           });
//                         },
//                         child: Container(
//                           height: 46,
//                           width: screenSize.width * 0.7,
//                           decoration: BoxDecoration(
//                             color: HexColor('1F2937'),
//                             border: Border.all(width: 1, color: Colors.white),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.only(
//                               right:
//                                   selectedIndex == 1
//                                       ? ((screenSize.width * 0.7) / 2)
//                                       : 12,
//                               left:
//                                   selectedIndex == 0
//                                       ? ((screenSize.width * 0.7) / 2)
//                                       : 12,
//                             ),
//                             child: Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(bottom: 3.0),
//                                 child: TextWidget(
//                                   text: selectedIndex == 0 ? "Top-up" : "Plans",
//                                   fontSize: 18.sp,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w500,
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       AnimatedPositioned(
//                         duration: Duration(milliseconds: 200),
//                         curve: Curves.easeInOut,
//                         left:
//                             selectedIndex == 0
//                                 ? 0
//                                 : (screenSize.width * 0.7) / 2,
//                         right:
//                             selectedIndex == 1
//                                 ? 0
//                                 : (screenSize.width * 0.7) / 2,
//                         top: 0,
//                         bottom: 0,
//                         child: Container(
//                           height: 46,
//                           width: (screenSize.width * 0.7) / 2,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                               width: 1,
//                               color: HexColor('#656FE2'),
//                             ),
//                             gradient: LinearGradient(
//                               colors: [
//                                 HexColor('#00008B'),
//                                 HexColor('#656FE2'),
//                               ],
//                               begin: const FractionalOffset(0.0, 0.0),
//                               end: const FractionalOffset(0.0, 1.0),
//                               stops: [0.2, 1],
//                               tileMode: TileMode.clamp,
//                             ),
//                           ),
//                           child: Center(
//                             child: Padding(
//                               padding: const EdgeInsets.only(bottom: 3.0),
//                               child: TextWidget(
//                                 text: selectedIndex == 1 ? "Top-up" : "Plans",
//                                 fontSize: 18.sp,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w500,
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 heightBox(20),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child:
//                         selectedIndex == 0
//                             ? Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.max,
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     TextWidget(
//                                       text: 'Current Plan',
//                                       fontSize: 20.sp,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w700,
//                                       textAlign: TextAlign.center,
//                                     ),
//                                     heightBox(4),
//                                     PlanListView(currentPlan: currentPlan),
//                                   ],
//                                 ),
//                                 heightBox(12),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     TextWidget(
//                                       text: 'Packages',
//                                       fontSize: 20.sp,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w700,
//                                       textAlign: TextAlign.center,
//                                     ),
//                                     heightBox(4),
//                                     ListView.builder(
//                                       shrinkWrap: true,
//                                       itemCount: arrOfPlanLists.length,
//                                       padding: EdgeInsets.zero,
//                                       physics: NeverScrollableScrollPhysics(),
//                                       itemBuilder: (context, index) {
//                                         return PlanListView(
//                                           currentPlan: arrOfPlanLists[index],
//                                         );
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                                 heightBox(30),
//                               ],
//                             )
//                             : Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.max,
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       children: [
//                                         TextWidget(
//                                           text: 'Top-up',
//                                           fontSize: 20.sp,
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.w700,
//                                           textAlign: TextAlign.center,
//                                         ),
//                                         widthBox(12),
//                                         Expanded(
//                                           child: TextWidget(
//                                             text:
//                                                 '(for more pro tokens with image & video generation)',
//                                             fontSize: 12.sp,
//                                             color: HexColor('#A1A1AA'),
//                                             fontWeight: FontWeight.w400,
//                                             textAlign: TextAlign.left,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     heightBox(8),
//                                     TextWidget(
//                                       text:
//                                           'Note: Top-up will available after purchasing a subscription.',
//                                       fontSize: 14.sp,
//                                       color: HexColor('#FAFAFA'),
//                                       fontWeight: FontWeight.w400,
//                                       textAlign: TextAlign.left,
//                                     ),
//                                   ],
//                                 ),
//                                 heightBox(12),
//                                 ListView.builder(
//                                   shrinkWrap: true,
//                                   itemCount: arrOfTopUpLists.length,
//                                   padding: EdgeInsets.zero,
//                                   physics: NeverScrollableScrollPhysics(),
//                                   itemBuilder: (context, index) {
//                                     return PlanListView(
//                                       currentPlan: arrOfTopUpLists[index],
//                                     );
//                                   },
//                                 ),
//                                 heightBox(30),
//                               ],
//                             ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
