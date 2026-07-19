import 'package:dio/dio.dart';
import '../../storage/secure/storage.dart';

class AuthInterceptor extends Interceptor {
  final _secure = SecureStorageService();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _secure.get(SecureStorageService.token);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = token;
    }
    handler.next(options);
  }
}