class Urls {
  static const String baseUrl =
      'https://erp-fastapi-batch.vercel.app/api/v1/web';
  // auth
  static const String login = '$baseUrl/auth/login';
  static const String profileMe = '$baseUrl/profile/me';
  static const String batches = '$baseUrl/batches';
  static const String createBatch = '$baseUrl/batches';
}
