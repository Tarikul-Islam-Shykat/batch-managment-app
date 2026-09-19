import '../models/api_result.dart';

abstract class INetworkService {
  Future<ApiResult<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  });

  Future<ApiResult<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });

  Future<ApiResult<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });

  Future<ApiResult<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });

  Future<ApiResult<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  });
}
