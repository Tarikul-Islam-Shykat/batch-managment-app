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
    if (data is Map && data['message'] != null) return data['message'];
    if (data is Map && data['detail'] != null) return data['detail'];
    if (data is Map && data['error'] != null) return data['error'];
    if (data is Map &&
        data['detail'] is List &&
        (data['detail'] as List).isNotEmpty) {
      return (data['detail'] as List).join(', ');
    }
    if (code >= 500) return 'Server error. Try again later.';
    if (code == 401) return 'Unauthorized. Please login again.';
    if (code == 404) return 'Resource not found.';
    return 'Request failed. Try again.';
  }

  static void show(DioException e) {
    // AppSnackBar.error(getMessage(e));
  }
}
