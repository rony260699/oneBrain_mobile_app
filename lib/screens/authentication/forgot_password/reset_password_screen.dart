// import 'package:OneBrain/base/base_stateful_state.dart';
// import 'package:OneBrain/screens/authentication/login/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../common_widgets/common_button.dart';
// import '../../../common_widgets/common_widgets.dart';
// import '../../../common_widgets/custom_search.dart';
// import '../../../common_widgets/text_widget.dart';
// import '../../../resources/image.dart';
// import '../register/cubit/register_cubit.dart';
// import '../register/states/register_states.dart';

// class ResetPasswordScreen extends StatefulWidget {
//   const ResetPasswordScreen({super.key});

//   @override
//   State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
// }

// class _ResetPasswordScreenState extends BaseStatefulWidgetState<ResetPasswordScreen> {
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
//         if (state is RegisterResetPasswordSuccessState) {
//           var registerCubit = RegisterCubit.get(context);
//           registerCubit.clearAll();
//           pushAndClearStack(context, enterPage: LoginScreen());
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
//               colors: [
//                 Color(0xFF000000),
//                 Color(0xFF0A0E24),
//                 Color(0xFF0C1028),
//               ],
//               stops: [0.0, 0.6, 1.0],
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.only(left: 24.0, right: 24.0),
//             child: Center(
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: HexColor('#B2B8F6').withValues(alpha: 0.2)),
//                   color: HexColor('#111827').withValues(alpha: 0.9),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 12.0, bottom: 20.0, left: 12, right: 12),
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
//                           text: "Reset Password",
//                           color: HexColor('#BA87FC'),
//                           fontWeight: FontWeight.w700,
//                           fontSize: 28,
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       heightBox(12),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                         child: Container(height: 0.8, color: HexColor('#313535')),
//                       ),
//                       heightBox(20),
//                       Column(
//                         children: [
//                           Align(
//                             alignment: Alignment.centerLeft,
//                             child: Padding(
//                               padding: const EdgeInsets.only(left: 14.0, bottom: 6),
//                               child: TextWidget(
//                                 text: "New Password",
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 11,
//                                 textAlign: TextAlign.left,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 12.0, right: 12.0),
//                             child: CustomSearch(
//                               height: 45,
//                               hint: "New Password",
//                               prefixIcon: SVGImg.passwordIcon,
//                               textInputType: TextInputType.text,
//                               controller: forgotPasswordCubit.txtPassword,
//                               passwordVisible: forgotPasswordCubit.isPasswordHide,
//                               focusNode: forgotPasswordCubit.focusPassword,
//                               onTapSuffixIcon: () {
//                                 setState(() {
//                                   forgotPasswordCubit.isPasswordHide =
//                                       !forgotPasswordCubit.isPasswordHide;
//                                 });
//                               },
//                               suffixIconName:
//                                   forgotPasswordCubit.isPasswordHide
//                                       ? SVGImg.passwordHideIcon
//                                       : SVGImg.passwordShowIcon,
//                             ),
//                           ),
//                         ],
//                       ),
//                       heightBox(12),
//                       Column(
//                         children: [
//                           Align(
//                             alignment: Alignment.centerLeft,
//                             child: Padding(
//                               padding: const EdgeInsets.only(left: 14.0, bottom: 6),
//                               child: TextWidget(
//                                 text: "Confirm Password",
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 11,
//                                 textAlign: TextAlign.left,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 12.0, right: 12.0),
//                             child: CustomSearch(
//                               height: 45,
//                               hint: "Confirm Password",
//                               prefixIcon: SVGImg.passwordIcon,
//                               textInputType: TextInputType.text,
//                               controller: forgotPasswordCubit.txtRepeatPassword,
//                               passwordVisible: forgotPasswordCubit.isRepeatPasswordHide,
//                               focusNode: forgotPasswordCubit.focusRepeatPassword,
//                               onTapSuffixIcon: () {
//                                 setState(() {
//                                   forgotPasswordCubit.isRepeatPasswordHide =
//                                       !forgotPasswordCubit.isRepeatPasswordHide;
//                                 });
//                               },
//                               suffixIconName:
//                                   forgotPasswordCubit.isRepeatPasswordHide
//                                       ? SVGImg.passwordHideIcon
//                                       : SVGImg.passwordShowIcon,
//                             ),
//                           ),
//                         ],
//                       ),
//                       heightBox(20),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 8),
//                         child: CommonButton(
//                           borderRadius: 20,
//                           fontSize: 14,
//                           showLoading: forgotPasswordCubit.state is RegisterLoadingState,
//                           text: "Reset Password",
//                           isBgBtn: true,
//                           height: 44,
//                           onTap: () {
//                             forgotPasswordCubit.setResetPassword();
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
