import 'package:dio/dio.dart' as dio;

class ErrorHandler {
  static String handle(dynamic e) {
    // Default fallback
    String message = "Something went wrong.";

    if (e is dio.DioException) {
      switch (e.type) {
        case dio.DioExceptionType.connectionTimeout:
        case dio.DioExceptionType.sendTimeout:
        case dio.DioExceptionType.receiveTimeout:
          message = "Network timeout. Please try again.";
          break;

        case dio.DioExceptionType.badResponse:
          message = "Server error. Please retry later.";
          break;

        case dio.DioExceptionType.badCertificate:
          message = "Security validation failed.";
          break;

        case dio.DioExceptionType.cancel:
          message = "Request cancelled.";
          break;

        case dio.DioExceptionType.connectionError:
          message = "Network error. Please check your connection.";
          break;

        default:
          // Special handling for generic network failures
          if (e.error != null &&
              e.error.toString().toLowerCase().contains("network")) {
            message = "Network error. Please check your connection.";
          } else {
            message = e.message ?? "Unexpected error occurred.";
          }
      }
    }

    return message;
  }
}
