import 'dart:async';

import 'package:OneBrain/common_widgets/common_widgets.dart';
import 'package:OneBrain/common_widgets/hexcolor.dart';
import 'package:OneBrain/common_widgets/text_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

class OtpVerifyScreen extends StatefulWidget {
  final bool isEmail;
  final String? phoneNumber;
  final String? email;
  final Future<bool> Function(String otp)? verifyTapped;
  final Future<bool> Function()? resendTapped;

  const OtpVerifyScreen({
    super.key,
    required this.isEmail,
    this.phoneNumber,
    this.email,
    this.verifyTapped,
    this.resendTapped,
  });

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  late int secondsRemaining = 60;
  Timer? _timer;
  bool clearText = false;

  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  final FocusNode _focusNode = FocusNode();

  void _startTimer() {
    _timer?.cancel();
    secondsRemaining = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> onSubmit() async {
    if (isLoading) return;
    isLoading = true;
    setState(() {});
    await HapticFeedback.mediumImpact();
    String otp = _pinController.text;
    bool? result = await widget.verifyTapped?.call(otp);
    // _timer?.cancel();
    isLoading = false;
    setState(() {});
    if (result ?? false) {
      Navigator.pop(context, result);
    } else {
      _pinController.clear();
      _focusNode.requestFocus();
    }
  }

  Widget _buildSubmitButton() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 1.0 + (0.05 * (1.0 - value)),
          child: Container(
            width: 120,
            height: 48,
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
              borderRadius: BorderRadius.circular(24), // Capsule shape
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
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  onSubmit();
                },
                child: Container(
                  alignment: Alignment.center,
                  child:
                      isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Container(
        width: double.infinity,
        height: double.infinity,

        padding: EdgeInsets.all(20),
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
        alignment: Alignment.center,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(24),
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
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.shade600.withValues(alpha: 0.5),
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

              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Title with gradient text effect
                      ShaderMask(
                        shaderCallback:
                            (bounds) => LinearGradient(
                              colors: [
                                HexColor('#BA87FC'),
                                HexColor('#6366F1'),
                              ],
                            ).createShader(bounds),
                        child: TextWidget(
                          text: "Account Verification",
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      heightBox(8),

                      // Subtitle
                      TextWidget(
                        text: "Secure your account with verification",
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
                      heightBox(24),

                      // Phone number display for SMS verification
                      Visibility(
                        visible: !widget.isEmail,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    HexColor('#6366F1').withValues(alpha: 0.15),
                                    HexColor('#8B5CF6').withValues(alpha: 0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: HexColor(
                                    '#6366F1',
                                  ).withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: HexColor(
                                        '#6366F1',
                                      ).withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.phone_android_outlined,
                                      color: HexColor('#60A5FA'),
                                      size: 20,
                                    ),
                                  ),
                                  widthBox(16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          text: "Phone Number",
                                          color: HexColor('#D1D5DB'),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          textAlign: TextAlign.start,
                                        ),
                                        heightBox(4),
                                        TextWidget(
                                          text: widget.phoneNumber,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.verified_user_outlined,
                                    color: HexColor('#60A5FA'),
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                            heightBox(24),
                          ],
                        ),
                      ),

                      // Instructions
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
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.security_outlined,
                                  color: HexColor('#60A5FA'),
                                  size: 20,
                                ),
                                widthBox(12),
                                Expanded(
                                  child: TextWidget(
                                    text:
                                        "Please use this OTP to complete your verification process.",
                                    color: HexColor('#D1D5DB'),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                            heightBox(12),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'Enter the 6-digit OTP sent to ',
                                style: TextStyle(
                                  color: HexColor('#9CA3AF'),
                                  fontSize: 14,
                                  height: 1.5,
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        widget.isEmail
                                            ? widget.email
                                            : widget.phoneNumber,
                                    style: TextStyle(
                                      color: HexColor('#60A5FA'),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      heightBox(32),

                      // Pinput OTP input field
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 800),
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: Pinput(
                                  focusNode: _focusNode,
                                  controller: _pinController,
                                  length: 6,
                                  autofocus: true,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  hapticFeedbackType:
                                      HapticFeedbackType.lightImpact,
                                  onChanged: (value) async {
                                    if (value.isNotEmpty) {
                                      await HapticFeedback.selectionClick();
                                    }
                                  },
                                  onCompleted: (pin) {
                                    onSubmit();
                                  },
                                  validator: (pin) {
                                    if (pin == null || pin.isEmpty) {
                                      return 'Please enter OTP';
                                    }
                                    if (pin.length < 6) {
                                      return 'Please enter complete OTP';
                                    }
                                    return null;
                                  },
                                  pinputAutovalidateMode:
                                      PinputAutovalidateMode.onSubmit,
                                  showCursor: true,
                                  cursor: Container(
                                    width: 2,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: HexColor('#6366F1'),
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                  defaultPinTheme: PinTheme(
                                    width: 40,
                                    height: 55,
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                    decoration: BoxDecoration(
                                      color: HexColor(
                                        '#1F2937',
                                      ).withValues(alpha: 0.8),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: HexColor('#374151'),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: HexColor(
                                            '#6366F1',
                                          ).withValues(alpha: 0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  focusedPinTheme: PinTheme(
                                    width: 40,
                                    height: 55,
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                    decoration: BoxDecoration(
                                      color: HexColor(
                                        '#6366F1',
                                      ).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: HexColor('#6366F1'),
                                        width: 2.0,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: HexColor(
                                            '#6366F1',
                                          ).withValues(alpha: 0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  submittedPinTheme: PinTheme(
                                    width: 40,
                                    height: 55,
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                    decoration: BoxDecoration(
                                      color: HexColor(
                                        '#059669',
                                      ).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: HexColor('#059669'),
                                        width: 2.0,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: HexColor(
                                            '#059669',
                                          ).withValues(alpha: 0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  errorPinTheme: PinTheme(
                                    width: 40,
                                    height: 55,
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                    decoration: BoxDecoration(
                                      color: HexColor(
                                        '#DC2626',
                                      ).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: HexColor('#DC2626'),
                                        width: 2.0,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: HexColor(
                                            '#DC2626',
                                          ).withValues(alpha: 0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      heightBox(36),

                      // Beautiful submit button
                      _buildSubmitButton(),
                      heightBox(24),

                      // Resend OTP section
                      Visibility(
                        visible: secondsRemaining == 0,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: HexColor('#374151').withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: HexColor('#6366F1').withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'Didn\'t receive the code? ',
                                style: TextStyle(
                                  color: HexColor('#9CA3AF'),
                                  fontSize: 14,
                                  height: 1.5,
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Resend OTP',
                                    style: TextStyle(
                                      color: HexColor('#60A5FA'),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                      decorationColor: HexColor('#60A5FA'),
                                    ),
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap = () async {
                                            if (secondsRemaining == 0) {
                                              if (isLoading) return;
                                              isLoading = true;
                                              setState(() {});
                                              bool? result =
                                                  await widget.resendTapped
                                                      ?.call();

                                              if (result ?? false) {
                                                _startTimer();
                                              }
                                              isLoading = false;
                                              setState(() {});
                                            }
                                          },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Timer display
                      Visibility(
                        visible: secondsRemaining != 0,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: HexColor('#374151').withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: HexColor('#6366F1').withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                color: HexColor('#60A5FA'),
                                size: 18,
                              ),
                              widthBox(8),
                              TextWidget(
                                text: "Resend OTP in ${secondsRemaining}s",
                                color: HexColor('#9CA3AF'),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    // ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
