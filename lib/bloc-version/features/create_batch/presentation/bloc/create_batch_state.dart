import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../data/models/create_batch_model.dart';

class DayScheduleItemData extends Equatable {
  final String day;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const DayScheduleItemData({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  DayScheduleItemData copyWith({TimeOfDay? startTime, TimeOfDay? endTime}) {
    return DayScheduleItemData(
      day: day,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  @override
  List<Object?> get props => [day, startTime, endTime];
}

abstract class CreateBatchState extends Equatable {
  final List<String> selectedDays;
  final List<DayScheduleItemData> scheduleItems;
  final DateTime? startDate;
  final DateTime? endDate;
  final TimeOfDay defaultStartTime;
  final TimeOfDay defaultEndTime;
  final bool isEditMode;
  final BatchListItemModel? editingBatch;

  const CreateBatchState({
    this.selectedDays = const [],
    this.scheduleItems = const [],
    this.startDate,
    this.endDate,
    this.defaultStartTime = const TimeOfDay(hour: 18, minute: 0),
    this.defaultEndTime = const TimeOfDay(hour: 20, minute: 0),
    this.isEditMode = false,
    this.editingBatch,
  });

  @override
  List<Object?> get props => [
    selectedDays,
    scheduleItems,
    startDate,
    endDate,
    defaultStartTime,
    defaultEndTime,
    isEditMode,
    editingBatch,
  ];
}

class CreateBatchFormState extends CreateBatchState {
  const CreateBatchFormState({
    super.selectedDays,
    super.scheduleItems,
    super.startDate,
    super.endDate,
    super.defaultStartTime,
    super.defaultEndTime,
    super.isEditMode,
    super.editingBatch,
  });

  CreateBatchFormState copyWith({
    List<String>? selectedDays,
    List<DayScheduleItemData>? scheduleItems,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? defaultStartTime,
    TimeOfDay? defaultEndTime,
    bool? isEditMode,
    BatchListItemModel? editingBatch,
  }) {
    return CreateBatchFormState(
      selectedDays: selectedDays ?? this.selectedDays,
      scheduleItems: scheduleItems ?? this.scheduleItems,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      defaultStartTime: defaultStartTime ?? this.defaultStartTime,
      defaultEndTime: defaultEndTime ?? this.defaultEndTime,
      isEditMode: isEditMode ?? this.isEditMode,
      editingBatch: editingBatch ?? this.editingBatch,
    );
  }
}

class CreateBatchLoading extends CreateBatchState {
  const CreateBatchLoading({
    super.selectedDays,
    super.scheduleItems,
    super.startDate,
    super.endDate,
    super.defaultStartTime,
    super.defaultEndTime,
    super.isEditMode,
    super.editingBatch,
  });
}

class CreateBatchSuccess extends CreateBatchState {
  final CreateBatchResponseModel response;
  final bool isUpdated;

  const CreateBatchSuccess({
    required this.response,
    this.isUpdated = false,
    super.selectedDays,
    super.scheduleItems,
    super.startDate,
    super.endDate,
    super.defaultStartTime,
    super.defaultEndTime,
    super.isEditMode,
    super.editingBatch,
  });

  @override
  List<Object?> get props => [response, isUpdated, ...super.props];
}

class CreateBatchFailure extends CreateBatchState {
  final String errorMessage;

  const CreateBatchFailure({
    required this.errorMessage,
    super.selectedDays,
    super.scheduleItems,
    super.startDate,
    super.endDate,
    super.defaultStartTime,
    super.defaultEndTime,
    super.isEditMode,
    super.editingBatch,
  });

  @override
  List<Object?> get props => [errorMessage, ...super.props];
}

class CreateBatchValidationError extends CreateBatchState {
  final String message;

  const CreateBatchValidationError({
    required this.message,
    super.selectedDays,
    super.scheduleItems,
    super.startDate,
    super.endDate,
    super.defaultStartTime,
    super.defaultEndTime,
    super.isEditMode,
    super.editingBatch,
  });

  @override
  List<Object?> get props => [message, ...super.props];
}
