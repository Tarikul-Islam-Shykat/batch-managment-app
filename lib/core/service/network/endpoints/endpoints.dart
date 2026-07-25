class Urls {
  static const String baseUrl =
      'https://erp-fastapi-batch.vercel.app/api/v1/web';
  // auth
  static const String login = '$baseUrl/auth/login';
  static const String signup = '$baseUrl/auth/signup';
  static const String verifyOtp = '$baseUrl/auth/verification/verify-otp';
  static const String requestOtp = '$baseUrl/auth/verification/request-otp';
  static const String profileMe = '$baseUrl/profile/me';
  static const String profileUpdate = '$baseUrl/profile/update';
  static const String batches = '$baseUrl/batches';
  static const String students = '$baseUrl/students';
  static String studentsByBatch(String batchId) =>
      '$baseUrl/students/batch/$batchId';
  static String studentById(String studentId) => '$baseUrl/students/$studentId';
  static String updateBatch(String batchId) => '$baseUrl/batches/$batchId';
  static String financeBatchSummary(String batchId, String month) =>
      '$baseUrl/finance/batch/$batchId/summary?month=${Uri.encodeComponent(month)}';
  static String batchHistory(String batchId) =>
      '$baseUrl/history/batch/$batchId';
  static String studentHistory(String studentId) =>
      '$baseUrl/history/student/$studentId';
  static String teacherDashboard({
    String? month,
    int? recentLimit,
    int? lowSeatThreshold,
  }) {
    final params = <String, String>{};

    if (month != null && month.trim().isNotEmpty) {
      params['month'] = month.trim();
    }
    if (recentLimit != null) {
      params['recent_limit'] = recentLimit.toString();
    }
    if (lowSeatThreshold != null) {
      params['low_seat_threshold'] = lowSeatThreshold.toString();
    }

    if (params.isEmpty) {
      return '$baseUrl/teacher-dashboard';
    }

    return '$baseUrl/teacher-dashboard?${Uri(queryParameters: params).query}';
  }

  static const String financeCollect = '$baseUrl/finance/collect';
  static const String createBatch = '$baseUrl/batches';
}
