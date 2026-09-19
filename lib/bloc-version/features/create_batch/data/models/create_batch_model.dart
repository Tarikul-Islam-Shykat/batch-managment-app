import 'package:equatable/equatable.dart';

class BatchScheduleModel extends Equatable {
  final String day;
  final String startTime;
  final String endTime;

  const BatchScheduleModel({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {'day': day, 'start_time': startTime, 'end_time': endTime};
  }

  factory BatchScheduleModel.fromJson(Map<String, dynamic> json) {
    return BatchScheduleModel(
      day: json['day']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [day, startTime, endTime];
}

class CreateBatchRequestModel extends Equatable {
  final String batchName;
  final String subject;
  final String startDate;
  final String endDate;
  final int fees;
  final int maxStudents;
  final List<BatchScheduleModel> schedule;

  const CreateBatchRequestModel({
    required this.batchName,
    required this.subject,
    required this.startDate,
    required this.endDate,
    required this.fees,
    required this.maxStudents,
    required this.schedule,
  });

  Map<String, dynamic> toJson() {
    return {
      'batch_name': batchName,
      'subject': subject,
      'start_date': startDate,
      'end_date': endDate,
      'fees': fees,
      'max_students': maxStudents,
      'schedule': schedule.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    batchName,
    subject,
    startDate,
    endDate,
    fees,
    maxStudents,
    schedule,
  ];
}

class CreateBatchResponseModel extends Equatable {
  final String? id;
  final String? message;
  final Map<String, dynamic> rawJson;

  const CreateBatchResponseModel({
    this.id,
    this.message,
    this.rawJson = const {},
  });

  factory CreateBatchResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateBatchResponseModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      message: json['message']?.toString(),
      rawJson: json,
    );
  }

  @override
  List<Object?> get props => [id, message];
}

class BatchListItemModel extends Equatable {
  final String id;
  final String teacherId;
  final String batchName;
  final String subject;
  final String startDate;
  final String endDate;
  final double fees;
  final int maxStudents;
  final List<BatchScheduleModel> schedule;
  final String createdAt;
  final String updatedAt;

  const BatchListItemModel({
    required this.id,
    this.teacherId = '',
    required this.batchName,
    required this.subject,
    required this.startDate,
    required this.endDate,
    required this.fees,
    required this.maxStudents,
    required this.schedule,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory BatchListItemModel.fromJson(Map<String, dynamic> json) {
    return BatchListItemModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      teacherId: json['teacher_id']?.toString() ?? '',
      batchName: json['batch_name']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      fees: (json['fees'] as num?)?.toDouble() ?? 0,
      maxStudents: (json['max_students'] as num?)?.toInt() ?? 0,
      schedule: (json['schedule'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(BatchScheduleModel.fromJson)
          .toList(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacher_id': teacherId,
      'batch_name': batchName,
      'subject': subject,
      'start_date': startDate,
      'end_date': endDate,
      'fees': fees,
      'max_students': maxStudents,
      'schedule': schedule.map((item) => item.toJson()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  List<Object?> get props => [
    id,
    teacherId,
    batchName,
    subject,
    startDate,
    endDate,
    fees,
    maxStudents,
    schedule,
    createdAt,
    updatedAt,
  ];
}
