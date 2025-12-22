// import 'package:OneBrain/base/base_stateful_state.dart';
// import 'package:OneBrain/screens/authentication/register/states/register_states.dart';
// import 'package:OneBrain/screens/authentication/verify_otp/otp_verify_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../common_widgets/app_utils.dart';
// import '../../../utils/slide_left_route.dart';
// import '../../../common_widgets/common_button.dart';
// import '../../../common_widgets/common_widgets.dart';
// import '../../../common_widgets/text_widget.dart';
// import '../../../resources/image.dart';
// import '../register/cubit/register_cubit.dart';

// class SendCodeScreen extends StatefulWidget {
//   const SendCodeScreen({super.key});

//   @override
//   State<SendCodeScreen> createState() => _SendCodeScreenState();
// }

// class _SendCodeScreenState extends BaseStatefulWidgetState<SendCodeScreen> {
//   @override
//   void initState() {
//     shouldHaveSafeArea = false;
//     super.initState();
//   }

//   @override
//   Widget buildBody(BuildContext context) {
//     return BlocConsumer<RegisterCubit, RegisterStates>(
//       listener: (cubit, state) {
//         if (state is RegisterOTPSendSuccessState) {
//           pushWithOTPAnimation(
//             context,
//             enterPage: OtpVerifyScreen(isFromForgotPassword: true),
//             direction: SlideDirection.rightToLeft,
//           );
//         } else if (state is RegisterErrorState) {
//           showError(message: state.errorMsg);
//         }
//       },
//       builder: (cubit, snapshot) {
//         var forgotPasswordCubit = RegisterCubit.get(context);
//         return Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [Color(0xFF000000), Color(0xFF0A0E24), Color(0xFF0C1028)],
//               stops: [0.0, 0.6, 1.0],
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.only(left: 24.0, right: 24.0),
//             child: Center(
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: HexColor('#B2B8F6').withValues(alpha: 0.2),
//                   ),
//                   color: HexColor('#111827').withValues(alpha: 0.9),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                     top: 12.0,
//                     bottom: 20.0,
//                     left: 12,
//                     right: 12,
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           InkWell(
//                             splashColor: Colors.transparent,
//                             highlightColor: Colors.transparent,
//                             onTap: () {
//                               goBack();
//                             },
//                             child: Container(
//                               height: 24,
//                               width: 24,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade800,
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: Image.asset(PNGImages.closeIcon),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       heightBox(8),
//                       Center(
//                         child: TextWidget(
//                           text: "Send Code",
//                           color: HexColor('#BA87FC'),
//                           fontWeight: FontWeight.w700,
//                           fontSize: 28,
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       Center(
//                         child: TextWidget(
//                           text: "Choose email or phone to send OTP",
//                           color: HexColor('#9CA3AF'),
//                           fontWeight: FontWeight.w400,
//                           fontSize: 14,
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       heightBox(12),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                         child: Container(
//                           height: 0.8,
//                           color: HexColor('#313535'),
//                         ),
//                       ),
//                       heightBox(20),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 24.0, right: 24.0),
//                         child: FittedBox(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               InkWell(
//                                 splashColor: Colors.transparent,
//                                 highlightColor: Colors.transparent,
//                                 onTap: () {
//                                   setState(() {
//                                     forgotPasswordCubit.isEmailSelected = true;
//                                   });
//                                 },
//                                 child: Row(
//                                   children: [
//                                     forgotPasswordCubit.isEmailSelected
//                                         ? Image.asset(
//                                           PNGImages.radioSelected,
//                                           height: 20,
//                                           width: 20,
//                                         )
//                                         : Image.asset(
//                                           PNGImages.radioUnSelected,
//                                           height: 20,
//                                           width: 20,
//                                         ),
//                                     widthBox(12),
//                                     TextWidget(
//                                       text:
//                                           forgotPasswordCubit
//                                               .txtForgotEmail
//                                               .text,
//                                       color:
//                                           forgotPasswordCubit.isEmailSelected
//                                               ? Colors.white
//                                               : HexColor('#9CA3AF'),
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 14,
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               heightBox(12),
//                               InkWell(
//                                 splashColor: Colors.transparent,
//                                 highlightColor: Colors.transparent,
//                                 onTap: () {
//                                   setState(() {
//                                     forgotPasswordCubit.isEmailSelected = false;
//                                   });
//                                 },
//                                 child: Row(
//                                   children: [
//                                     forgotPasswordCubit.isEmailSelected
//                                         ? Image.asset(
//                                           PNGImages.radioUnSelected,
//                                           height: 20,
//                                           width: 20,
//                                         )
//                                         : Image.asset(
//                                           PNGImages.radioSelected,
//                                           height: 20,
//                                           width: 20,
//                                         ),
//                                     widthBox(12),
//                                     TextWidget(
//                                       text:
//                                           forgotPasswordCubit
//                                               .loginRequest
//                                               .mobile,
//                                       color:
//                                           !forgotPasswordCubit.isEmailSelected
//                                               ? Colors.white
//                                               : HexColor('#9CA3AF'),
//                                       fontWeight: FontWeight.w400,
//                                       fontSize: 14,
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       heightBox(20),
//                       TextWidget(
//                         text:
//                             "Select where you want to receive the OTP.\nOnce you receive it, the next step will be to verify the OTP.",
//                         color: HexColor('#9CA3AF'),
//                         fontWeight: FontWeight.w400,
//                         fontSize: 12,
//                         textAlign: TextAlign.center,
//                       ),
//                       heightBox(20),
//                       Padding(
//                         padding: const EdgeInsets.only(
//                           left: 12.0,
//                           right: 12.0,
//                           bottom: 8,
//                         ),
//                         child: CommonButton(
//                           borderRadius: 20,
//                           fontSize: 14,
//                           showLoading:
//                               forgotPasswordCubit.state
//                                   is RegisterOTPSendInitState,
//                           text: "Send Code",
//                           isBgBtn: true,
//                           height: 44,
//                           onTap: () {
//                             forgotPasswordCubit.sendForgotPasswordOTP();
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
