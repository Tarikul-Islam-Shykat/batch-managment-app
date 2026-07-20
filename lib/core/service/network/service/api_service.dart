import 'dart:io';
import 'package:dio/dio.dart';
import '../error/network_error_handler.dart';
import '../instance/network_client.dart';

class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  final _dio = NetworkClient.instance.dio;

  Future<dynamic> get(String path, {bool auth = false}) =>
      _request(() => _dio.get(path));

  Future<dynamic> post(String path, dynamic body, {bool auth = false}) =>
      _request(() => _dio.post(path, data: body));

  Future<dynamic> put(String path, dynamic body, {bool auth = false}) =>
      _request(() => _dio.put(path, data: body));

  Future<dynamic> patch(String path, dynamic body, {bool auth = false}) =>
      _request(() => _dio.patch(path, data: body));

  Future<dynamic> delete(String path, {bool auth = false}) =>
      _request(() => _dio.delete(path));

  Future<dynamic> upload(
    String path, {
    required Map<String, dynamic> fields,
    List<File> files = const [],
    String fileField = 'image',
    String method = 'POST',
  }) async {
    final formData = FormData.fromMap({
      ...fields,
      if (files.isNotEmpty)
        fileField: await Future.wait(
          files.map(
            (f) => MultipartFile.fromFile(
              f.path,
              filename: f.path.split('/').last,
            ),
          ),
        ),
    });
    return _request(
      () => _dio.request(
        path,
        data: formData,
        options: Options(method: method),
      ),
    );
  }

  // ── Single error handling point ────────────────
  Future<dynamic> _request(Future<Response> Function() call) async {
    try {
      final response = await call();
      return response.data;
    } on DioException catch (e) {
      final message = NetworkErrorHandler.getMessage(e);
      throw NetworkException(message);
    }
  }
}
