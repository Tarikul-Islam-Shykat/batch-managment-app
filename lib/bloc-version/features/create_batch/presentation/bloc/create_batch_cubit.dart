import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/models/create_batch_model.dart';
import '../../data/repositories/create_batch_repository.dart';
import 'create_batch_state.dart';

class CreateBatchCubit extends Cubit<CreateBatchState> {
  final CreateBatchRepository _createBatchRepository;

  CreateBatchCubit(this._createBatchRepository)
    : super(const CreateBatchFormState());

  void toggleDay(String day) {
    final days = List<String>.from(state.selectedDays);
    final schedules = List<DayScheduleItemData>.from(state.scheduleItems);

    if (days.contains(day)) {
      days.remove(day);
      schedules.removeWhere((item) => item.day == day);
    } else {
      days.add(day);
      schedules.add(
        DayScheduleItemData(
          day: day,
          startTime: state.defaultStartTime,
          endTime: state.defaultEndTime,
        ),
      );
    }

    emit(
      CreateBatchFormState(
        selectedDays: days,
        scheduleItems: schedules,
        startDate: state.startDate,
        endDate: state.endDate,
        defaultStartTime: state.defaultStartTime,
        defaultEndTime: state.defaultEndTime,
      ),
    );
  }

  void setStartDate(DateTime date) {
    emit(
      CreateBatchFormState(
        selectedDays: state.selectedDays,
        scheduleItems: state.scheduleItems,
        startDate: date,
        endDate: state.endDate,
        defaultStartTime: state.defaultStartTime,
        defaultEndTime: state.defaultEndTime,
      ),
    );
  }

  void setEndDate(DateTime date) {
    emit(
      CreateBatchFormState(
        selectedDays: state.selectedDays,
        scheduleItems: state.scheduleItems,
        startDate: state.startDate,
        endDate: date,
        defaultStartTime: state.defaultStartTime,
        defaultEndTime: state.defaultEndTime,
      ),
    );
  }

  void setDefaultStartTime(TimeOfDay time) {
    emit(
      CreateBatchFormState(
        selectedDays: state.selectedDays,
        scheduleItems: state.scheduleItems,
        startDate: state.startDate,
        endDate: state.endDate,
        defaultStartTime: time,
        defaultEndTime: state.defaultEndTime,
      ),
    );
  }

  void setDefaultEndTime(TimeOfDay time) {
    emit(
      CreateBatchFormState(
        selectedDays: state.selectedDays,
        scheduleItems: state.scheduleItems,
        startDate: state.startDate,
        endDate: state.endDate,
        defaultStartTime: state.defaultStartTime,
        defaultEndTime: time,
      ),
    );
  }

  void applyDefaultTimeToAll() {
    final updated = state.scheduleItems.map((item) {
      return item.copyWith(
        startTime: state.defaultStartTime,
        endTime: state.defaultEndTime,
      );
    }).toList();

    emit(
      CreateBatchFormState(
        selectedDays: state.selectedDays,
        scheduleItems: updated,
        startDate: state.startDate,
        endDate: state.endDate,
        defaultStartTime: state.defaultStartTime,
        defaultEndTime: state.defaultEndTime,
      ),
    );
  }

  void applyDefaultTimeToItem(int index) {
    if (index < 0 || index >= state.scheduleItems.length) return;

    final updated = List<DayScheduleItemData>.from(state.scheduleItems);
    updated[index] = updated[index].copyWith(
      startTime: state.defaultStartTime,
      endTime: state.defaultEndTime,
    );

    emit(
      CreateBatchFormState(
        selectedDays: state.selectedDays,
        scheduleItems: updated,
        startDate: state.startDate,
        endDate: state.endDate,
        defaultStartTime: state.defaultStartTime,
        defaultEndTime: state.defaultEndTime,
      ),
    );
  }

  void updateScheduleTime(
    int index, {
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    if (index < 0 || index >= state.scheduleItems.length) return;

    final updated = List<DayScheduleItemData>.from(state.scheduleItems);
    updated[index] = updated[index].copyWith(
      startTime: startTime,
      endTime: endTime,
    );

    emit(
      CreateBatchFormState(
        selectedDays: state.selectedDays,
        scheduleItems: updated,
        startDate: state.startDate,
        endDate: state.endDate,
        defaultStartTime: state.defaultStartTime,
        defaultEndTime: state.defaultEndTime,
      ),
    );
  }

  String _formatTime24(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> createBatch({
    required String batchName,
    required String subject,
    required String fees,
    required String maxStudents,
  }) async {
    final trimmedName = batchName.trim();
    final trimmedSubject = subject.trim();
    final parsedFees = int.tryParse(fees.trim());
    final parsedMaxStudents = int.tryParse(maxStudents.trim());

    if (trimmedName.isEmpty) {
      emit(
        CreateBatchValidationError(
          message: 'Please enter a batch name.',
          selectedDays: state.selectedDays,
          scheduleItems: state.scheduleItems,
          startDate: state.startDate,
          endDate: state.endDate,
          defaultStartTime: state.defaultStartTime,
          defaultEndTime: state.defaultEndTime,
        ),
      );
      return;
    }

    if (trimmedSubject.isEmpty) {
      emit(
        CreateBatchValidationError(
          message: 'Please enter a subject name.',
          selectedDays: state.selectedDays,
          scheduleItems: state.scheduleItems,
          startDate: state.startDate,
          endDate: state.endDate,
          defaultStartTime: state.defaultStartTime,
          defaultEndTime: state.defaultEndTime,
        ),
      );
      return;
    }

    if (parsedFees == null) {
      emit(
        CreateBatchValidationError(
          message: 'Please enter a valid fee amount.',
          selectedDays: state.selectedDays,
          scheduleItems: state.scheduleItems,
          startDate: state.startDate,
          endDate: state.endDate,
          defaultStartTime: state.defaultStartTime,
          defaultEndTime: state.defaultEndTime,
        ),
      );
      return;
    }

    if (state.startDate == null || state.endDate == null) {
      emit(
        CreateBatchValidationError(
          message: 'Please select both start and end dates.',
          selectedDays: state.selectedDays,
          scheduleItems: state.scheduleItems,
          startDate: state.startDate,
          endDate: state.endDate,
          defaultStartTime: state.defaultStartTime,
          defaultEndTime: state.defaultEndTime,
        ),
      );
      return;
    }

    if (parsedMaxStudents == null) {
      emit(
        CreateBatchValidationError(
          message: 'Please enter maximum students.',
          selectedDays: state.selectedDays,
          scheduleItems: state.scheduleItems,
          startDate: state.startDate,
          endDate: state.endDate,
          defaultStartTime: state.defaultStartTime,
          defaultEndTime: state.defaultEndTime,
        ),
      );
      return;
    }

    if (state.selectedDays.isEmpty) {
      emit(
        CreateBatchValidationError(
          message: 'Please select at least one class day.',
          selectedDays: state.selectedDays,
          scheduleItems: state.scheduleItems,
          startDate: state.startDate,
          endDate: state.endDate,
          defaultStartTime: state.defaultStartTime,
          defaultEndTime: state.defaultEndTime,
        ),
      );
      return;
    }

    emit(
      CreateBatchLoading(
        selectedDays: state.selectedDays,
        scheduleItems: state.scheduleItems,
        startDate: state.startDate,
        endDate: state.endDate,
        defaultStartTime: state.defaultStartTime,
        defaultEndTime: state.defaultEndTime,
      ),
    );

    final request = CreateBatchRequestModel(
      batchName: trimmedName,
      subject: trimmedSubject,
      startDate: _formatDate(state.startDate!),
      endDate: _formatDate(state.endDate!),
      fees: parsedFees,
      maxStudents: parsedMaxStudents,
      schedule: state.scheduleItems.map((item) {
        return BatchScheduleModel(
          day: item.day,
          startTime: _formatTime24(item.startTime),
          endTime: _formatTime24(item.endTime),
        );
      }).toList(),
    );

    final result = await _createBatchRepository.createBatch(request);

    result.fold(
      (failure) => emit(
        CreateBatchFailure(
          errorMessage: failure.message,
          selectedDays: state.selectedDays,
          scheduleItems: state.scheduleItems,
          startDate: state.startDate,
          endDate: state.endDate,
          defaultStartTime: state.defaultStartTime,
          defaultEndTime: state.defaultEndTime,
        ),
      ),
      (response) => emit(
        CreateBatchSuccess(
          response: response,
          selectedDays: state.selectedDays,
          scheduleItems: state.scheduleItems,
          startDate: state.startDate,
          endDate: state.endDate,
          defaultStartTime: state.defaultStartTime,
          defaultEndTime: state.defaultEndTime,
        ),
      ),
    );
  }

  void resetForm() {
    emit(const CreateBatchFormState());
  }
}
