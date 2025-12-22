import 'dart:math' as math;
import 'package:flutter/material.dart';

const Color colorPrimary = Color(0xFF5251F7);
const Color colorAppBg = Color(0xFF212226);
const Color colorTransparent = Colors.transparent;
const Color colorBlack = Color(0xFF000000);
const Color colorWhite = Color(0xFFFFFFFF);
const Color appBarTitleColor = Color(0xFF9CA3AF);
const Color colorGreen = Color(0xFF2E7C22);
const Color color1D1E20 = Color(0xFF1D1E20);
const Color colorED2730 = Color(0xFFED2730);
const Color colorDDDDDD = Color(0xFFDDDDDD);
const Color color323337 = Color(0xFF323337);
const Color colorBDB5D2 = Color(0xFFBDB5D2);
const Color colorDDD6EF = Color(0xFFDDD6EF);
const Color colorF8F7FB = Color(0xFFF8F7FB);
const Color color170B37 = Color(0xFF170B37);
const Color colorA59BBF = Color(0xFFA59BBF);
const Color colorD9D2EA = Color(0xFFD9D2EA);
const Color color419A55 = Color(0xFF419A55);
const Color colorCFE2EF = Color(0xFFCFE2EF);
const Color color0B0B40 = Color(0xFF0B0B40);
const Color color57598B = Color(0xFF57598B);
const Color color5A5C60 = Color(0xFF5A5C60);
const Color colorE5F5FF = Color(0xFFE5F5FF);
const Color colorFFEEF4 = Color(0xFFFFEEF4);
const Color colorFAF1E6 = Color(0xFFFAF1E6);
const Color colorEAF5F2 = Color(0xFFEAF5F2);
const Color colorE6F4F6 = Color(0xFFE6F4F6);
const Color colorEDEAFD = Color(0xFFEDEAFD);
const Color color041532 = Color(0xFF041532);
const Color colorDAE1EE = Color(0xFFDAE1EE);

const Color color5D7492 = Color(0xFF5D7492);
const Color colorDBDBE7 = Color(0xFFDBDBE7);
const Color colorDFDFEE = Color(0xFFDFDFEE);
const Color color97B0CA = Color(0xFF97B0CA);
const Color color597189 = Color(0xFF597189);
const Color color8396B6 = Color(0xFF8396B6);
const Color colorE3EAF4 = Color(0xFFE3EAF4);
const Color color090A2D = Color(0xFF090A2D);
const Color color798497 = Color(0xFF798497);
const Color colorD2DFF0 = Color(0xFFD2DFF0);
const Color color7287A8 = Color(0xFF7287A8);
const Color color7D7399 = Color(0xFF7D7399);

const Color colorDFE9F0 = Color(0xFFDFE9F0);
const Color colorF2F2F1 = Color(0xFFF2F2F1);
const Color colorE3E3E1 = Color(0xFFE3E3E1);
const Color color9E9E9E = Color(0xFF9E9E9E);
const Color color181919 = Color(0xFF181919);
const Color colorEA3943 = Color(0xFFEA3943);
const Color color5F4600 = Color(0xFF5F4600);
const Color colorF6E0A3 = Color(0xFFF6E0A3);
const Color colorEBBC39 = Color(0xFFEBBC39);
const Color colorD6DEEB = Color(0xFFD6DEEB);
const Color color00244F = Color(0xFF00244F);
const Color colorF7F6FF = Color(0xFFF7F6FF);
const Color colorCADAEC = Color(0xFFCADAEC);
const Color color3FA4FF = Color(0xFF3FA4FF);
const Color colorF1F0FF = Color(0xFFF1F0FF);
const Color color8FA4B9 = Color(0xFF8FA4B9);
const Color color5251F7 = Color(0xFF5251F7);
const Color colorBDC5D4 = Color(0xFFBDC5D4);
const Color colorD7DFEC = Color(0xFFBDC5D4);
const Color color5A687E = Color(0xFF5A687E);
const Color color635027 = Color(0xFF635027);
const Color colorF5F5F5 = Color(0xFFF5F5F5);
const Color color0B1C39 = Color(0xFF0B1C39);
const Color color304D6B = Color(0xFF304D6B);
const Color colorCEE1EA = Color(0xFFCEE1EA);
const Color colorA4B7DD = Color(0xFFA4B7DD);
const Color color3B4B69 = Color(0xFF3B4B69);
const Color color4BA63C = Color(0xFF4BA63C);
const Color colorF8FBFF = Color(0xFFF8FBFF);
const Color colorD9D9D9 = Color(0xFFD9D9D9);
const Color colorD4DDED = Color(0xFFD4DDED);
const Color colorDA9E45 = Color(0xFFDA9E45);
const Color colorDD5555 = Color(0xFFDD5555);
const Color color002347 = Color(0xFF002347);
const Color color34A853 = Color(0xFF34A853);
const Color color5D6A81 = Color(0xFF5D6A81);
const Color color2B6DEE = Color(0xFF2B6DEE);
const Color chatBubbleColor = Color(0x0014366d);

Gradient gradientPrimary = const LinearGradient(
  begin: Alignment(0, -0.6),
  end: Alignment(0.1, 4),
  colors: [Color.fromRGBO(237, 39, 48, 1), Color.fromRGBO(251, 188, 5, 1)],
  transform: GradientRotation(math.pi - 550),
);

Gradient gradientGold = const LinearGradient(
  /*begin: Alignment(0, -0.6),
  end: Alignment(0.1, 4),*/
  colors: [colorF6E0A3, colorEBBC39],
  transform: GradientRotation(math.pi - 550),
);

// AppColors class for easy access to colors throughout the app
class AppColors {
  // Primary colors
  static const Color primaryColor = colorPrimary;
  static const Color backgroundColor = colorAppBg;

  // Basic colors
  static const Color whiteColor = colorWhite;
  static const Color blackColor = colorBlack;
  static const Color transparentColor = colorTransparent;
  static const Color greyColor = color9E9E9E;

  // UI colors
  static const Color textFieldBackgroundColor = color323337;
  static const Color borderColor = color5A5C60;
  static const Color greenColor = colorGreen;
  static const Color redColor = colorED2730;

  // Additional colors
  static const Color successColor = color34A853;
  static const Color warningColor = colorDA9E45;
  static const Color errorColor = colorDD5555;
  static const Color infoColor = color3FA4FF;
}
