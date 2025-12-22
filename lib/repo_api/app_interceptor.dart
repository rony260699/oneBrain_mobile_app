import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../common_widgets/app_utils.dart';
import '../utils/shared_preference_util.dart';

class AppInterceptor extends Interceptor {
  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    debugPrint("onRequest headers");

    options.headers['Authorization'] = await getToken();
    options.headers['Accept-Language'] = await getApplicationLanguage();
    options.headers['x-platform'] = 'mobile';

    return handler.next(options); // Always continue
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 401) {
      log("401 Unauthorized");
    }
    super.onResponse(response, handler);
  }

  Future<String> getToken() async {
    final token = SharedPreferenceUtil.getUserData()?.accessToken ?? "";
    final accessToken = 'Bearer $token';
    if (kDebugMode) log("Authorization $accessToken");
    return accessToken;
  }

  Future<String> getApplicationLanguage() async {
    const appLanguage = 'en'; // or fetch from SharedPreferences
    if (kDebugMode) log("appLanguage $appLanguage");
    return appLanguage;
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    log("DIO ERROR: ${err.type}");
    String errorMessage = "Something went wrong. Please try again.";

    if (kDebugMode) {
      print("DIO ERROR: ${err.type}");
      print("DIO ERROR RESPONSE: ${err.response?.data}");
      print("DIO ERROR MESSAGE: ${err.message}");
    }

    // Handle 401 Unauthorized globally

    // URL end point
    if ((err.response?.statusCode == 401 ||
        err.response?.statusMessage == 'Unauthorized')) {
      print("err.response?.statusCode : ${err.response?.statusCode}");
      print("err.response?.statusMessage : ${err.response?.statusMessage}");
      print("err.requestOptions.path : ${err.requestOptions.path}");
      print(
        "err.requestOptions.path  Result : ${err.requestOptions.path.contains("/refresh-token")}",
      );
      if (err.requestOptions.path.contains("/refresh-token")) {
        if (kDebugMode) {
          print("err.response?.statusCode : ${err.response?.statusCode}");
        }
        AppUtils.instance.logout();
        return handler.reject(err);
      }
      if (kDebugMode) {
        print("err.response?.statusCode : ${err.response?.statusCode}");
      }
      // AppUtils.instance.logout();
      return handler.reject(err);
    }

    // Handle different types of network errors
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage =
            "Connection timeout. Please check your internet connection.";
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = "Request timeout. Please try again.";
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = "Server response timeout. Please try again.";
        break;
      case DioExceptionType.badResponse:
        errorMessage =
            err.response?.data?['message'] ?? "Server error occurred.";
        break;
      case DioExceptionType.cancel:
        errorMessage = "Request was cancelled.";
        break;
      case DioExceptionType.connectionError:
        errorMessage = "No internet connection. Please check your network.";
        break;
      case DioExceptionType.badCertificate:
        errorMessage = "Security certificate error. Please try again.";
        break;
      case DioExceptionType.unknown:
        errorMessage = "Network error. Please check your connection.";
        break;
    }

    // Show error to user
    showError(message: errorMessage);

    // Return the modified error
    return handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: errorMessage,
      ),
    );
  }
}
