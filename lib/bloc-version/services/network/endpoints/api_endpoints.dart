class ApiEndpoints {
  static const String baseUrl =
      'https://erp-fastapi-batch.vercel.app/api/v1/web';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String signUp = '/auth/signup';
  static const String verifyOtp = '/auth/verification/verify-otp';
  static const String requestOtp = '/auth/verification/request-otp';

  // Profile endpoints
  static const String profileMe = '/profile/me';
  static const String profileUpdate = '/profile/update';

  // Batch & Student endpoints
  static const String batches = '/batches';
  static String batchById(String batchId) => '/batches/$batchId';
  static const String students = '/students';
  static String studentsByBatch(String batchId) => '/students/batch/$batchId';
  static String studentById(String studentId) => '/students/$studentId';
  static String financeBatchSummary(String batchId, String month) =>
      '/finance/batch/$batchId/summary?month=${Uri.encodeComponent(month)}';
  static const String financeCollect = '/finance/collect';

  // Super Admin & App Status endpoints
  static const String appStatus =
      'https://erp-fastapi-batch.vercel.app/api/v1/app-status';
  static const String adminAppStatus = '/admin/app-status';
  static String adminAppStatusById(String id) => '/admin/app-status/$id';

  // History & Audit endpoints
  static String batchHistory(String batchId) => '/history/batch/$batchId';
  static String studentHistory(String studentId) =>
      '/history/student/$studentId';
}
