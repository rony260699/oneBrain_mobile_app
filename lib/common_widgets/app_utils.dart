import 'dart:async';
import 'dart:io';

import 'package:OneBrain/common_widgets/text_widget.dart';
import 'package:country_picker_pro/country_picker_pro.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:intl/intl.dart';

import '../base/base_stateful_state.dart';
import '../resources/color.dart';
import '../resources/strings.dart';
import '../screens/authentication/login/login_screen.dart';
import '../utils/app_constants.dart';
import '../utils/shared_preference_util.dart';
import '../utils/slide_left_route.dart';

// Navigation methods with custom animations for OTP flow
void pushWithOTPAnimation(
  BuildContext context, {
  required Widget enterPage,
  SlideDirection direction = SlideDirection.rightToLeft,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  FocusScope.of(context).requestFocus(FocusNode());
  Navigator.of(
    context,
  ).push(OTPSlideTransition(page: enterPage, direction: direction));
}

void pushWithSwipeAnimation(
  BuildContext context, {
  required Widget enterPage,
  bool isForward = true,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  FocusScope.of(context).requestFocus(FocusNode());
  Navigator.of(
    context,
  ).push(SwipeTransition(page: enterPage, isForward: isForward));
}

void pushWithCardAnimation(BuildContext context, {required Widget enterPage}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  FocusScope.of(context).requestFocus(FocusNode());
  Navigator.of(context).push(CardTransition(page: enterPage));
}

Future<dynamic> showCupertinoDialogBox(
  BuildContext context,
  String message,
  Function(BuildContext context) onOkTapped, {
  String okText = "OKAY",
  bool isShowCancel = false,
  String cancelText = "Cancel",
}) async {
  await Haptics.vibrate(HapticsType.error);
  return await showCupertinoDialog(
    context: rootNavigatorKey.currentContext!,
    builder: (context) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
            color: HexColor("#0F1747"),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 16,
                    fontFamily: strFontName,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 44,
                    child: CupertinoButton(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      padding: const EdgeInsets.all(12),
                      onPressed: () => onOkTapped(context),
                      child: Text(
                        okText,
                        style: TextStyle(
                          color: CupertinoColors.black,
                          fontFamily: strFontName,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
                isShowCancel
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: SizedBox(
                            width: 150,
                            height: 36,
                            child: CupertinoButton(
                              padding: const EdgeInsets.all(8),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                cancelText,
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                  fontFamily: strFontName,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                    : Container(),
                isShowCancel ? const SizedBox(height: 8) : SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<Country?> selectCountry(
  String code,
  BuildContext context,
  Color themeColor,
) async {
  // Create a Completer to handle the asynchronous result
  Completer<Country?> completer = Completer();
  CountrySelector(
    context: context,
    countryPreferred: <String>[code],
    showPhoneCode: true,
    appBarTitle: "Select Country",
    onSelect: (Country country) {
      completer.complete(country);
    },
    listType: ListType.list,
    appBarBackgroundColour: themeColor,
    appBarFontSize: 20,
    appBarFontStyle: FontStyle.normal,
    appBarFontWeight: FontWeight.bold,
    appBarTextColour: Colors.white,
    appBarTextCenterAlign: true,
    backgroundColour: Colors.white,
    backIcon: Icons.arrow_back,
    backIconColour: Colors.white,
    countryFontStyle: FontStyle.normal,
    countryFontWeight: FontWeight.bold,
    countryTextColour: Colors.black,
    countryTitleSize: 16,
    dividerColour: Colors.black12,
    searchBarAutofocus: false,
    searchBarIcon: Icons.search,
    searchBoxPadding: const EdgeInsets.only(
      left: 20,
      right: 20.0,
      top: 12.0,
      bottom: 12.0,
    ),
    searchBarBackgroundColor: Colors.white,
    searchBarBorderColor: themeColor,
    searchBarBorderWidth: 2,
    searchBarOuterBackgroundColor: Colors.white,
    searchBarTextColor: Colors.black,
    searchBarHintColor: Colors.black,
    countryTheme: const CountryThemeData(appBarBorderRadius: 10),
    showSearchBox: true,
  );

  // Wait for the user to select a country
  return completer.future;
}

class AppUtils {
  AppUtils._privateConstructor();

  static final AppUtils instance = AppUtils._privateConstructor();

  static Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      // SharedPreferenceUtil.putValue(strDeviceIdKey, '${iosDeviceInfo.identifierForVendor}${DateTime.now().microsecond}');
      return '${iosDeviceInfo.identifierForVendor}'; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      // SharedPreferenceUtil.putValue(strDeviceIdKey, '${androidDeviceInfo.id}${DateTime.now().microsecond}');
      return androidDeviceInfo.id;
    }
  }

  // String formatDateTextFromString(String? dateString) {
  //   print("createdAt: $dateString");
  //   if (dateString == null) return "";

  //   try {
  //     // Adjust the format to match your actual input format
  //     DateTime date = DateFormat("yyyy-MM-dd").parse(dateString);

  //     final now = DateTime.now();
  //     final today = DateTime(now.year, now.month, now.day);
  //     final inputDate = DateTime(date.year, date.month, date.day);

  //     final difference = today.difference(inputDate).inDays;

  //     if (difference == 0) {
  //       return "Today";
  //     } else if (difference == 1) {
  //       return "Yesterday";
  //     } else {
  //       return DateFormat('dd MMM, yyyy').format(date);
  //     }
  //   } catch (e) {
  //     print("Error: $e : $dateString");
  //     return "Invalid Date";
  //   }
  // }

  static String getUsernameFromEmail(String email) {
    return email.split('@').first;
  }

  showMessageBlackBG({String? message, Color? backgroundColor}) {
    ScaffoldMessenger.of(rootNavigatorKey.currentContext!).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor ?? colorPrimary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        content: TextWidget(
          text: message ?? '',
          fontSize: 14.sp,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Future<void> logout() async {
    await SharedPreferenceUtil.clear();
    pushAndClearStack(enterPage: LoginScreen());
  }

  void pushAndClearStack({
    required Widget enterPage,
    bool shouldUseRootNavigator = false,
  }) {
    ScaffoldMessenger.of(
      rootNavigatorKey.currentContext!,
    ).hideCurrentSnackBar();
    Navigator.of(
      rootNavigatorKey.currentContext!,
      rootNavigator: shouldUseRootNavigator,
    ).pushAndRemoveUntil(
      SlideLeftRoute(page: enterPage),
      (Route<dynamic> route) => false,
    );
  }
}

String extractErrorMessage(dynamic error) {
  try {
    if (error is DioException) {
      return error.response?.data["message"] ??
          error.message ??
          "Unknown error";
    }
    return error.toString();
  } catch (_) {
    return "Something went wrong";
  }
}

void showError({String? message, Color? messageColor}) =>
    Fluttertoast.showToast(
      msg: message ?? '',
      backgroundColor: messageColor ?? colorED2730,
      gravity: ToastGravity.TOP,
    );

void showErrorBottom({String? message, Color? messageColor}) =>
    Fluttertoast.showToast(
      msg: message ?? '',
      backgroundColor: messageColor ?? colorED2730,
      gravity: ToastGravity.BOTTOM,
    );

void showSuccess({String? message, Color? messageColor}) =>
    Fluttertoast.showToast(
      msg: message ?? '',
      backgroundColor: messageColor ?? colorGreen,
      gravity: ToastGravity.TOP,
    );

//string extention for capitail first later with null handle
extension StringCapitalize on String? {
  String get capitalizeFirst {
    if (this?.isEmpty ?? true) return '';
    if (this == 'chatgpt') return 'ChatGPT';
    if (this == 'deepseek') return 'DeepSeek';
    return '${this![0].toUpperCase()}${this!.substring(1)}';
  }
}

String getFormattedTimezoneOffset() {
  final offset = DateTime.now().timeZoneOffset;
  final hours = offset.inHours;
  final minutes = offset.inMinutes.remainder(60).abs();
  final sign = hours >= 0 ? '+' : '-';
  return '$sign${hours.abs().toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
}


extension INNumberFormat on String {
  String toINFormat() {
    if (isEmpty) return '';
    try {
      final number = int.parse(this);
      final formatter = NumberFormat.decimalPattern('hi_IN');
      return formatter.format(number);
    } catch (e) {
      return this; // return original if parsing fails
    }
  }
}
