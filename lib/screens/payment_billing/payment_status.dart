import 'dart:async';

import 'package:OneBrain/base/base_stateful_state.dart';
import 'package:OneBrain/common_widgets/common_button.dart';
import 'package:OneBrain/common_widgets/common_widgets.dart';
import 'package:OneBrain/common_widgets/text_widget.dart';
import 'package:OneBrain/resources/color.dart';
import 'package:OneBrain/resources/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class PaymentStatus extends StatefulWidget {
  const PaymentStatus({
    super.key,
    this.isSuccess = true,
    this.title,
    this.description,
    this.onRetry,
  });
  final String? title;
  final String? description;
  final bool isSuccess;
  final Function()? onRetry;

  @override
  State<PaymentStatus> createState() => _PaymentStatusState();
}

class _PaymentStatusState extends BaseStatefulWidgetState<PaymentStatus> {
  int countdown = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startRedirectCountdown();
  }

  void _startRedirectCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown <= 1) {
        _redirectToBilling();
      } else {
        setState(() {
          countdown--;
        });
      }
    });
  }

  void _redirectToBilling() {
    _timer?.cancel();

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000000),
              Color(0xFF000000),
              Color(0xFF0A0E24),
              Color(0xFF0C1028),
            ],
            stops: [0.0, 0.4, 0.65, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Lottie.asset(
              widget.isSuccess
                  ? LottieAssets.successLottie
                  : LottieAssets.errorLottie,
              height: 200.h,
              width: 200.h,
            ),
            SizedBox(height: 30.h),
            TextWidget(
              text:
                  widget.title ??
                  (widget.isSuccess ? "Payment Successful!" : "Payment Failed"),
              textAlign: TextAlign.center,
              fontSize: 24.sp,
              color: colorWhite,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: TextWidget(
                text:
                    widget.description ??
                    (widget.isSuccess
                        ? "Your transaction has been completed successfully"
                        : "Something went wrong. Please review your billing details"),
                textAlign: TextAlign.center,
                fontSize: 16.sp,
                color: colorWhite,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 30.h),
            Spacer(),
            if (widget.onRetry != null)
              SizedBox(
                height: 48.h,
                child: Center(
                  child: InkWell(
                    onTap: () {
                      widget.onRetry?.call();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh, color: colorWhite, size: 26.sp),
                        widthBox(5.w),
                        TextWidget(
                          text: 'Retry',
                          fontSize: 15.sp,
                          color: colorWhite,
                          fontWeight: FontWeight.w600,
                          onTap: widget.onRetry,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CommonButton(
                text: 'Continue',
                height: 48.h,
                textColor: colorWhite,
                borderRadius: 8,
                backgroundColor: HexColor('#656FE2').withOpacity(0.2),
                borderWidth: 1.5,
                borderColor: HexColor('#3B82F6'),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                onTap: _redirectToBilling,
              ),
            ),
            SizedBox(height: 20.h),

            TextWidget(
              text: "Redirecting to billing page in $countdown seconds",
              textAlign: TextAlign.center,
              fontSize: 16.sp,
              color: colorWhite,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
