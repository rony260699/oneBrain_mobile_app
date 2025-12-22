import 'package:OneBrain/base/base_stateful_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../common_widgets/common_widgets.dart';
import '../../../common_widgets/text_widget.dart';

class ChooseOtpMethodScreen extends StatefulWidget {
  final String email;
  final String mobile;
  const ChooseOtpMethodScreen({
    super.key,
    required this.email,
    required this.mobile,
    required this.sendOtp,
  });

  final Future<bool> Function(bool isEmail) sendOtp;

  @override
  State<ChooseOtpMethodScreen> createState() => _ChooseOtpMethodScreenState();
}

class _ChooseOtpMethodScreenState
    extends BaseStatefulWidgetState<ChooseOtpMethodScreen> {
  @override
  void initState() {
    shouldHaveSafeArea = false;
    super.initState();
  }

  Future<void> onSendOtp() async {
    if (isLoading) return;
    isLoading = true;
    setState(() {});
    final result = await widget.sendOtp(isEmailSelected);
    isLoading = false;
    setState(() {});
    if (result) {
      Navigator.pop(context, true);
    }
  }

  String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length <= 4) return phoneNumber;
    final maskedLength = phoneNumber.length - 4;
    final maskedPart = '*' * maskedLength;
    final last4Digits = phoneNumber.substring(phoneNumber.length - 4);
    return maskedPart + last4Digits;
  }

  bool isLoading = false;
  bool isEmailSelected = true;

  Widget _buildOptionCard({
    required bool isSelected,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color iconColor,
    required Color iconBackGroundColor
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient:
              isSelected
                  ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      HexColor('#6366F1').withValues(alpha: 0.15),
                      HexColor('#8B5CF6').withValues(alpha: 0.1),
                    ],
                  )
                  : null,
          color: isSelected ? null : HexColor('#374151').withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected
                    ? HexColor('#6366F1').withValues(alpha: 0.6)
                    : HexColor('#4B5563').withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: HexColor('#6366F1').withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          children: [
            // Custom radio button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? HexColor('#4ADE80') : HexColor('#6B7280'),
                  width: 2,
                ),
                color: isSelected ? HexColor('#1A223D') : Colors.transparent,
              ),
              child:
                  isSelected
                      ? Icon(Icons.check, size: 14, color: HexColor('#4ADE80'))
                      : null,
            ),
            widthBox(16),

            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                // color:
                //     isSelected
                //         ? HexColor('#6366F1').withValues(alpha: 0.2)
                //         : HexColor('#4B5563').withValues(alpha: 0.3),
                color: iconBackGroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                // color: isSelected ? HexColor('#60A5FA') : HexColor('#9CA3AF'),
                color: iconColor,
                size: 20,
              ),
            ),
            widthBox(16),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: title,
                    color: isSelected ? Colors.white : HexColor('#D1D5DB'),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    textAlign: TextAlign.left,
                  ),
                  heightBox(4),
                  TextWidget(
                    text: subtitle,
                    color:
                        isSelected ? HexColor('#C7D2FE') : HexColor('#9CA3AF'),
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendCodeButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E40AF), // Deep blue
            Color(0xFF3B82F6), // Medium blue
            Color(0xFF60A5FA), // Light blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28), // Capsule shape
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () => onSendOtp(),
          child: Container(
            alignment: Alignment.center,
            child:
                isLoading
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : const Text(
                      'Send Code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    // return BlocConsumer<RegisterCubit, RegisterStates>(
    //   listener: (cubit, state) {
    //     if (state is RegisterOTPSendSuccessState) {
    //       var loginCubit = RegisterCubit.get(context);
    //       loginCubit.loginRequest = LoginRequest(
    //         firstName: "",
    //         lastName: "",
    //         email: widget.email,
    //         password: "",
    //         mobile: widget.mobile,
    //         repeatPassword: "",
    //       );
    //       pushWithOTPAnimation(
    //         context,
    //         enterPage: OtpVerifyScreen(
    //           isFromVerification: true,
    //           resendTapped: () {
    //             if (loginCubit.isEmailSelected) {
    //               loginCubit.sendOTPForEmail(widget.email, true);
    //             } else {
    //               loginCubit.sendOTPForMobile(
    //                 widget.mobile,
    //                 widget.email,
    //                 true,
    //               );
    //             }
    //           },
    //         ),
    //         direction: SlideDirection.rightToLeft,
    //       );
    //     } else if (state is RegisterErrorState) {
    //       showError(message: state.errorMsg);
    //     }
    //   },
    //   builder: (cubit, snapshot) {
    //     var loginCubit = RegisterCubit.get(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        // Same dark blue gradient as chat screen background
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF000000), // Pure black at top
            Color(0xFF0A0E24), // Deep dark blue
            Color(0xFF0C1028), // Slightly lighter dark blue
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    HexColor('#1F2937').withValues(alpha: 0.95),
                    HexColor('#111827').withValues(alpha: 0.98),
                  ],
                ),
                border: Border.all(
                  color: HexColor('#6366F1').withValues(alpha: 0.2),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: HexColor('#6366F1').withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Back button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await HapticFeedback.lightImpact();
                            goBack();
                          },
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800.withValues(
                                alpha: 0.8,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey.shade600.withValues(
                                  alpha: 0.5,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.grey.shade300,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    heightBox(16),

                    // Title with gradient text effect
                    ShaderMask(
                      shaderCallback:
                          (bounds) => LinearGradient(
                            colors: [HexColor('#BA87FC'), HexColor('#6366F1')],
                          ).createShader(bounds),
                      child: TextWidget(
                        text: "Verify Account",
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    heightBox(8),

                    // Subtitle
                    TextWidget(
                      text: "Choose email or phone to verify OTP",
                      color: HexColor('#9CA3AF'),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      textAlign: TextAlign.center,
                    ),
                    heightBox(24),

                    // Elegant divider
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            HexColor('#6366F1').withValues(alpha: 0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    heightBox(32),

                    // Beautiful option cards
                    _buildOptionCard(
                      isSelected: isEmailSelected,
                      icon: Icons.email_outlined,
                      title: widget.email,
                      subtitle: "Email verification",
                      onTap: () {
                        setState(() {
                          isEmailSelected = true;
                        });
                      },
                      iconColor: HexColor('#60A5FA'), 
                      iconBackGroundColor: HexColor('#0D2144')
                    ),
                    heightBox(16),
                    _buildOptionCard(
                      isSelected: !isEmailSelected,
                      icon: Icons.phone_android_outlined,
                      title: maskPhoneNumber(widget.mobile),
                      subtitle: "SMS verification",
                      onTap: () {
                        setState(() {
                          isEmailSelected = false;
                        });
                      },
                      iconColor: HexColor('#41ae85'), 
                      iconBackGroundColor: HexColor('#092f26')
                    ),
                    heightBox(32),

                    // Instructions with better styling
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: HexColor('#374151').withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: HexColor('#6366F1').withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: HexColor('#60A5FA'),
                            size: 20,
                          ),
                          widthBox(12),
                          Expanded(
                            child: TextWidget(
                              text:
                                  "Select where you want to receive the OTP.\nOnce you receive it, the next step will be to verify the OTP.",
                              color: HexColor('#D1D5DB'),
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                    heightBox(32),

                    _buildSendCodeButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
