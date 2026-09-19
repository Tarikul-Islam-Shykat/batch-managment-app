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
  static const String students = '/students';
  static const String financeCollect = '/finance/collect';
}
