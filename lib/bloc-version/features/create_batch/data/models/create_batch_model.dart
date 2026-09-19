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
