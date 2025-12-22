import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
SideMenuController controller = SideMenuController();

const androidDevice = 'android';
const iosDevice = 'ios';
const resendOtpCodeTimeSec = '40';
const isLoginKey = "isLoginKey";
const accessTokenKey = "accessTokenKey";
const fcmTokenKey = "fcmTokenKey";
const countryCode = '91';
const currentLat = 'currentLat';
const currentLong = 'currentLong';
const userDataKey = 'userDataKey';
const loginUserID = 'loginUserID';
const accessToken = 'accessToken';
const userSelectedAppLanguageKey = 'userSelectedAppLanguageKey';
const strLocaleEn = 'en';
const strLocaleAr = 'ar';
const isLoginBeneficiary = 'isLoginBeneficiary';
bool isBeneficiaryUser = false;

/// Social value ///
String isSocialProvider = '';
String isSocialId = '';
String isSocialName = '';
String isSocialLastName = '';
String isSocialEmail = '';
String isSocialMobileNo = '';
String isSocialImage = '';
bool isCallDetailScreenOpen = false;

String communityUrl = 'https://www.facebook.com/groups/onebrainusers/';
String whatsappUrl = 'https://api.whatsapp.com/send/?phone=8801988121220';
String supportNumber = '8801988121220';

RegExp regExpForEmail = RegExp(
  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
);
