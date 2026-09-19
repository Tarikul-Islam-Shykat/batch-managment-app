import 'dart:developer';
import 'package:dio/dio.dart';

import '../../storage/secure/keys.dart';
import '../../storage/secure/secure_storage_interface.dart';
import '../config/network_config.dart';
import '../interfaces/i_network_service.dart';
import '../models/api_result.dart';

class DioNetworkService implements INetworkService {
  final Dio _dio;
  final ISecureStorageService _secureStorage;

  DioNetworkService({
    required NetworkConfig config,
    required ISecureStorageService secureStorage,
    Dio? dio,
  }) : _secureStorage = secureStorage,
       _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: config.baseUrl,
               connectTimeout: config.connectTimeout,
               receiveTimeout: config.receiveTimeout,
               headers: {'Content-Type': 'application/json'},
             ),
           ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.read(SecureKey.token);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          log('[BLoC DIO] [${options.method}] ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log(
            '[BLoC DIO] [${response.statusCode}] ${response.requestOptions.uri}',
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          log('[BLoC DIO ERROR] ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  @override
  Future<ApiResult<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return ApiResult.success(
        response.data as T,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  @override
  Future<ApiResult<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiResult.success(
        response.data as T,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  @override
  Future<ApiResult<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiResult.success(
        response.data as T,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  @override
  Future<ApiResult<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiResult.success(
        response.data as T,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  @override
  Future<ApiResult<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        queryParameters: queryParameters,
      );
      return ApiResult.success(
        response.data as T,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  ApiResult<T> _handleDioError<T>(DioException e) {
    String message = 'Network request failed';
    final response = e.response;
    if (response != null && response.data != null) {
      final data = response.data;
      if (data is Map) {
        if (data['message'] != null) {
          message = data['message'].toString();
        } else if (data['detail'] != null) {
          if (data['detail'] is List) {
            final list = data['detail'] as List;
            message = list
                .map(
                  (item) => (item is Map && item['msg'] != null)
                      ? item['msg']
                      : item.toString(),
                )
                .join(', ');
          } else {
            message = data['detail'].toString();
          }
        }
      } else if (data is String && data.isNotEmpty) {
        message = data;
      }
    } else {
      message = e.message ?? 'An unknown network error occurred';
    }
    return ApiResult.failure(message, statusCode: response?.statusCode);
  }
}
