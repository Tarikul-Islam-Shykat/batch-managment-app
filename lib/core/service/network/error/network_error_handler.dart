import 'package:batch_management_app_direct/core/global/app_snackbar.dart';
import 'package:dio/dio.dart';

class NetworkException implements Exception {
  final String message;

  const NetworkException(this.message);

  @override
  String toString() => message;
}

class NetworkErrorHandler {
  static String getMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.badResponse:
        return _fromResponse(e.response);
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  static String _fromResponse(Response? response) {
    if (response == null) return 'Server error';
    final code = response.statusCode ?? 0;
    final data = response.data;

    if (data is String && data.trim().isNotEmpty) {
      return data;
    }
    if (data is Map) {
      if (data['message'] != null) return data['message'].toString();
      if (data['detail'] is List && (data['detail'] as List).isNotEmpty) {
        final messages = (data['detail'] as List).map((item) {
          if (item is Map && item['msg'] != null) {
            return item['msg'].toString();
          }
          return item.toString();
        }).toList();
        return messages.join(', ');
      }
      if (data['detail'] != null) return data['detail'].toString();
      if (data['error'] != null) return data['error'].toString();
    }
    if (code >= 500) return 'Server error. Try again later.';
    if (code == 401) return 'Unauthorized. Please login again.';
    if (code == 404) return 'Resource not found.';
    return 'Request failed. Try again.';
  }

  static void show(DioException e) {
    AppSnackbar.show(message: getMessage(e), isSuccess: false);
  }
}
