class BatchScheduleItemModel {
  final String day;
  final String startTime;
  final String endTime;

  const BatchScheduleItemModel({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory BatchScheduleItemModel.fromJson(Map<String, dynamic> json) {
    return BatchScheduleItemModel(
      day: json['day']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
    );
  }
}

class BatchListItemModel {
  final String id;
  final String teacherId;
  final String batchName;
  final String subject;
  final String startDate;
  final String endDate;
  final double fees;
  final int maxStudents;
  final List<BatchScheduleItemModel> schedule;
  final String createdAt;
  final String updatedAt;

  const BatchListItemModel({
    required this.id,
    required this.teacherId,
    required this.batchName,
    required this.subject,
    required this.startDate,
    required this.endDate,
    required this.fees,
    required this.maxStudents,
    required this.schedule,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BatchListItemModel.fromJson(Map<String, dynamic> json) {
    return BatchListItemModel(
      id: json['id']?.toString() ?? '',
      teacherId: json['teacher_id']?.toString() ?? '',
      batchName: json['batch_name']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      fees: (json['fees'] as num?)?.toDouble() ?? 0,
      maxStudents: (json['max_students'] as num?)?.toInt() ?? 0,
      schedule: (json['schedule'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(BatchScheduleItemModel.fromJson)
          .toList(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }
}

class BatchListResponseModel {
  final List<BatchListItemModel> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const BatchListResponseModel({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory BatchListResponseModel.fromJson(Map<String, dynamic> json) {
    return BatchListResponseModel(
      items: (json['items'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(BatchListItemModel.fromJson)
          .toList(),
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
    );
  }
}
