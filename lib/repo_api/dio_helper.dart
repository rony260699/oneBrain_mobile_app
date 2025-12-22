import 'package:OneBrain/models/current_user_model.dart' as user;
import 'package:OneBrain/utils/shared_preference_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../repo_api/rest_constants.dart';
import 'app_interceptor.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: RestConstants.baseUrl,
        receiveDataWhenStatusError: true,
        sendTimeout: const Duration(seconds: 30),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      PrettyDioLogger(
        error: true,
        request: true,
        compact: true,
        requestBody: true,
        responseBody: true,
        enabled: kDebugMode,
        requestHeader: true,
        responseHeader: true,
      ),
      AppInterceptor(),
    ]);
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    bool isHeader = false,
    bool isLanguage = true,
  }) async {
    try {
      final response = await dio.get(
        url,
        queryParameters: query,
        options: Options(
          extra: {'header': isHeader, 'language': isLanguage},
          // validateStatus: (status) {
          //   if (kDebugMode) {
          //     print("status $status");
          //   }
          //   return status != null &&
          //       status < 600; // Accept all valid HTTP status codes
          // },
        ),
      );

      return response;
    } catch (e) {
      if (e is DioException) {
        bool isRefreshed = await handleResponse(e.response);
        if (isRefreshed) {
          return await getData(url: url, query: query, isHeader: isHeader);
        }
      }
      rethrow;
    }
  }

  static Future<bool> handleResponse(Response? response) async {
    if (response?.statusCode == 401) {
      try {
        user.LoggedInUserModel? userData = SharedPreferenceUtil.getUserData();

        final refreshToken = userData?.refreshToken;
        if (refreshToken == null) {
          return false;
        }

        final value = await dio.post(
          RestConstants.refreshToken,
          data: {"refreshToken": refreshToken},
        );
        if ((value.statusCode ?? 0) == 200) {
          userData?.accessToken = value.data["data"]["accessToken"];
          userData?.refreshToken = value.data["data"]["refreshToken"];
          // log("**********************Token Refreshed**********************");
          // log("Access Token : ${userData?.accessToken}");
          // log("Refresh Token : ${userData?.refreshToken}");
          // log("**********************Token Refreshed**********************");
          SharedPreferenceUtil.saveUserData(userData: userData);
          return true;
        }
      } catch (e) {
        rethrow;
      }
    }
    return false;
  }

  static Future<Response> deleteData({required String url}) async {
    try {
      Response response = await dio.delete(url);
      return response;
    } catch (e) {
      if (e is DioException) {
        bool isRefreshed = await handleResponse(e.response);
        if (isRefreshed) {
          return await deleteData(url: url);
        }
      }
      rethrow;
    }
  }

  static Future<Response> postData({
    FormData? formData,
    required String url,
    bool isHeader = false,
    bool isLanguage = true,
    bool isAllow412 = false,
    Map<dynamic, dynamic>? data,
    Map<String, dynamic>? headers,
    ResponseType? responseType,
  }) async {
    try {
      Response myResponse = await dio.post(
        url,
        data: formData ?? data,
        options: Options(headers: headers, responseType: responseType),
      );
      return myResponse;
    } catch (e) {
      if (e is DioException) {
        bool isRefreshed = await handleResponse(e.response);
        if (isRefreshed) {
          return await postData(
            url: url,
            data: data,
            formData: formData,
            isHeader: isHeader,
            isAllow412: isAllow412,
            isLanguage: isLanguage,
          );
        }
      }
      rethrow;
    }
  }

  static Future<Response> putData({
    String? token,
    String lang = 'en',
    required String url,
    bool isFormData = false,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
  }) async {
    dio.options.headers = {
      'Accept-Language': lang,
      'Authorization': token ?? '',
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> newData;

    if (isFormData) {
      dio.options.headers['Content-Type'] = 'multipart/form-data';

      // Convert to Map<String, dynamic>
      final Map<String, dynamic> formDataMap = {};

      for (final entry in data.entries) {
        var value = entry.value;

        if (value is XFile) {
          value = await MultipartFile.fromFile(
            value.path,
            filename: value.name,
          );
        }

        formDataMap[entry.key] = value;
      }

      newData = formDataMap;
    } else {
      newData = data;
    }

    try {
      Response myResponse = await dio.put(
        url,
        queryParameters: query,
        data: isFormData ? FormData.fromMap(newData) : newData,
        options: Options(extra: {'header': true}),
      );
      if (kDebugMode) {
        print("RESPONSE $myResponse");
      }
      return myResponse;
    } catch (e) {
      if (e is DioException) {
        bool isRefreshed = await handleResponse(e.response);
        if (isRefreshed) {
          return await putData(
            url: url,
            data: data,
            query: query,
            lang: lang,
            token: token,
          );
        }
      }
      rethrow;
    }
  }

  static Future<Response> patchData({
    String lang = 'en',
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
  }) async {
    dio.options.headers = {
      'Accept-Language': lang,
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> newData = data;
    try {
      Response myResponse = await dio.patch(
        url,
        data: newData,
        queryParameters: query,
      );

      return myResponse;
    } catch (e) {
      if (e is DioException) {
        bool isRefreshed = await handleResponse(e.response);
        if (isRefreshed) {
          return await patchData(
            url: url,
            data: data,
            lang: lang,
            query: query,
          );
        }
      }
      rethrow;
    }
  }
}
