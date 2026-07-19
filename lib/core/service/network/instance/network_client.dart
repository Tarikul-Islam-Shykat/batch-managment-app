import 'package:dio/dio.dart';
import '../interceptors/auth_interceptor.dart';
import '../interceptors/logging_interceptor.dart';

class NetworkClient {
  NetworkClient._();
  static final NetworkClient instance = NetworkClient._();

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://erp-fastapi-batch.vercel.app/api/v1/web/',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  )..interceptors.addAll([AuthInterceptor(), LoggingInterceptor()]);
}
