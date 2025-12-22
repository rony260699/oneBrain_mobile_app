// import 'package:OneBrain/base/base_stateful_state.dart';
// import 'package:OneBrain/screens/authentication/forgot_password/send_code_screen.dart';
// import 'package:OneBrain/screens/authentication/register/cubit/register_cubit.dart';
// import 'package:OneBrain/screens/authentication/register/states/register_states.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../common_widgets/app_utils.dart';
// import '../../../common_widgets/common_button.dart';
// import '../../../common_widgets/common_widgets.dart';
// import '../../../common_widgets/custom_search.dart';
// import '../../../common_widgets/text_widget.dart';
// import '../../../resources/image.dart';

// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState
//     extends BaseStatefulWidgetState<ForgotPasswordScreen> {
//   @override
//   bool get resizeToAvoidBottomInset => false;

//   @override
//   void initState() {
//     shouldHaveSafeArea = false;
//     super.initState();
//   }

//   @override
//   Widget buildBody(BuildContext context) {
//     return BlocConsumer<RegisterCubit, RegisterStates>(
//       listener: (cubit, state) {
//         if (state is RegisterSuccessState) {
//           push(context, enterPage: SendCodeScreen());
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
//             padding: EdgeInsets.only(left: 24.0, right: 24.0),
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
//                     crossAxisAlignment: CrossAxisAlignment.center,
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
//                           text: "Forgot Password",
//                           color: HexColor('#BA87FC'),
//                           fontWeight: FontWeight.w700,
//                           fontSize: 28,
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       TextWidget(
//                         text:
//                             "Enter your email address to search and reset your password.",
//                         color: HexColor('#9CA3AF'),
//                         fontWeight: FontWeight.w400,
//                         fontSize: 14,
//                         textAlign: TextAlign.center,
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
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 14.0, bottom: 6),
//                           child: TextWidget(
//                             text: "Email",
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 11,
//                             textAlign: TextAlign.left,
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 12.0, right: 12.0),
//                         child: CustomSearch(
//                           height: 45,
//                           hint: "Email Address",
//                           prefixIcon: SVGImg.emailIcon,
//                           textInputType: TextInputType.emailAddress,
//                           controller: forgotPasswordCubit.txtForgotEmail,
//                           focusNode: forgotPasswordCubit.focusForgotEmail,
//                         ),
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
//                           text: "Search Account",
//                           isBgBtn: true,
//                           showLoading:
//                               forgotPasswordCubit.state is RegisterLoadingState,
//                           height: 44,
//                           onTap: () {
//                             forgotPasswordCubit.searchAccountAPI();
//                             setState(() {});
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
