class BatchScheduleModel {
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
}

class CreateBatchRequestModel {
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
}
