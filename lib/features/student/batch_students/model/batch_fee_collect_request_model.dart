class BatchFeeCollectRequestModel {
  final List<String> studentIds;
  final String batchId;
  final List<String> months;
  final double amountPaid;
  final double originalAmount;
  final String paymentMethod;
  final String notes;

  const BatchFeeCollectRequestModel({
    required this.studentIds,
    required this.batchId,
    required this.months,
    required this.amountPaid,
    required this.originalAmount,
    required this.paymentMethod,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_ids': studentIds,
      'batch_id': batchId,
      'months': months,
      'amount_paid': amountPaid,
      'original_amount': originalAmount,
      'payment_method': paymentMethod,
      'notes': notes,
    };
  }
}
