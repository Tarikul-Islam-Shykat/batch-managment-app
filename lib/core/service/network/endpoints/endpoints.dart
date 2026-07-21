class Urls {
  static const String baseUrl =
      'https://erp-fastapi-batch.vercel.app/api/v1/web';
  // auth
  static const String login = '$baseUrl/auth/login';
  static const String signup = '$baseUrl/auth/signup';
  static const String verifyOtp = '$baseUrl/auth/verification/verify-otp';
  static const String requestOtp = '$baseUrl/auth/verification/request-otp';
  static const String profileMe = '$baseUrl/profile/me';
  static const String batches = '$baseUrl/batches';
  static const String students = '$baseUrl/students';
  static String studentsByBatch(String batchId) =>
      '$baseUrl/students/batch/$batchId';
  static String financeBatchSummary(String batchId, String month) =>
      '$baseUrl/finance/batch/$batchId/summary?month=${Uri.encodeComponent(month)}';
  static const String financeCollect = '$baseUrl/finance/collect';
  static const String createBatch = '$baseUrl/batches';
}
