import 'environment.dart';

class NetworkConfig {
  final Environment environment;
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  const NetworkConfig({
    this.environment = Environment.dev,
    this.baseUrl = 'https://erp-fastapi-batch.vercel.app/api/v1/web',
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 15),
  });
}
