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

  DateTime? _parseDate(String value) {
    if (value.trim().isEmpty) return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  TimeOfDay? _parseTime24(String value) {
    if (value.trim().isEmpty) return null;
    try {
      final parsed = DateFormat('HH:mm').parse(value);
      return TimeOfDay(hour: parsed.hour, minute: parsed.minute);
    } catch (_) {
      return null;
    }
  }

  void initForEdit(BatchListItemModel batch) {
    final parsedStartDate = _parseDate(batch.startDate);
    final parsedEndDate = _parseDate(batch.endDate);

    final selectedDays = <String>[];
    final scheduleItems = <DayScheduleItemData>[];

    TimeOfDay defStart = const TimeOfDay(hour: 18, minute: 0);
    TimeOfDay defEnd = const TimeOfDay(hour: 20, minute: 0);

    for (final s in batch.schedule) {
      final startTime = _parseTime24(s.startTime) ?? defStart;
      final endTime = _parseTime24(s.endTime) ?? defEnd;
      selectedDays.add(s.day);
      scheduleItems.add(
        DayScheduleItemData(day: s.day, startTime: startTime, endTime: endTime),
      );
    }

    if (scheduleItems.isNotEmpty) {
      defStart = scheduleItems.first.startTime;
      defEnd = scheduleItems.first.endTime;
    }

    emit(
      CreateBatchFormState(
        selectedDays: selectedDays,
        scheduleItems: scheduleItems,
        startDate: parsedStartDate,
        endDate: parsedEndDate,
        defaultStartTime: defStart,
        defaultEndTime: defEnd,
        isEditMode: true,
        editingBatch: batch,
      ),
    );
  }

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
        isEditMode: state.isEditMode,
        editingBatch: state.editingBatch,
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
        isEditMode: state.isEditMode,
        editingBatch: state.editingBatch,
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
        isEditMode: state.isEditMode,
        editingBatch: state.editingBatch,
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
        isEditMode: state.isEditMode,
        editingBatch: state.editingBatch,
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
        isEditMode: state.isEditMode,
        editingBatch: state.editingBatch,
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
        isEditMode: state.isEditMode,
        editingBatch: state.editingBatch,
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
        isEditMode: state.isEditMode,
        editingBatch: state.editingBatch,
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
        isEditMode: state.isEditMode,
        editingBatch: state.editingBatch,
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
          isEditMode: state.isEditMode,
          editingBatch: state.editingBatch,
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
          isEditMode: state.isEditMode,
          editingBatch: state.editingBatch,
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
          isEditMode: state.isEditMode,
          editingBatch: state.editingBatch,
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
          isEditMode: state.isEditMode,
          editingBatch: state.editingBatch,
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
          isEditMode: state.isEditMode,
          editingBatch: state.editingBatch,
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
          isEditMode: state.isEditMode,
          editingBatch: state.editingBatch,
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
        isEditMode: state.isEditMode,
        editingBatch: state.editingBatch,
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
          isEditMode: state.isEditMode,
          editingBatch: state.editingBatch,
        ),
      ),
      (response) => emit(
        CreateBatchSuccess(
          response: response,
          isUpdated: false,
          selectedDays: state.selectedDays,
          scheduleItems: state.scheduleItems,
          startDate: state.startDate,
          endDate: state.endDate,
          defaultStartTime: state.defaultStartTime,
          defaultEndTime: state.defaultEndTime,
          isEditMode: state.isEditMode,
          editingBatch: state.editingBatch,
        ),
      ),
    );
  }

  Future<void> updateBatch({
    required String batchName,
    required String subject,
    required String fees,
    required String maxStudents,
  }) async {
    final batch = state.editingBatch;
    if (batch == null) return;

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
          isEditMode: true,
          editingBatch: batch,
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
          isEditMode: true,
          editingBatch: batch,
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
          isEditMode: true,
          editingBatch: batch,
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
          isEditMode: true,
          editingBatch: batch,
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
          isEditMode: true,
          editingBatch: batch,
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
          isEditMode: true,
          editingBatch: batch,
        ),
      );
      return;
    }

    final payload = <String, dynamic>{};
    if (trimmedName != batch.batchName) {
      payload['batch_name'] = trimmedName;
    }
    if (trimmedSubject != batch.subject) {
      payload['subject'] = trimmedSubject;
    }
    final formattedStartDate = _formatDate(state.startDate!);
    if (formattedStartDate != batch.startDate) {
      payload['start_date'] = formattedStartDate;
    }
    final formattedEndDate = _formatDate(state.endDate!);
    if (formattedEndDate != batch.endDate) {
      payload['end_date'] = formattedEndDate;
    }
    if (parsedFees != batch.fees.toInt()) {
      payload['fees'] = parsedFees;
    }
    if (parsedMaxStudents != batch.maxStudents) {
      payload['max_students'] = parsedMaxStudents;
    }

    final originalSig = batch.schedule
        .map((s) => '${s.day}-${s.startTime}-${s.endTime}')
        .join('|');
    final currentSig = state.scheduleItems
        .map(
          (s) =>
              '${s.day}-${_formatTime24(s.startTime)}-${_formatTime24(s.endTime)}',
        )
        .join('|');
    if (originalSig != currentSig) {
      payload['schedule'] = state.scheduleItems.map((item) {
        return {
          'day': item.day,
          'start_time': _formatTime24(item.startTime),
          'end_time': _formatTime24(item.endTime),
        };
      }).toList();
    }

    if (payload.isEmpty) {
      emit(
        CreateBatchValidationError(
          message: 'No changes to update.',
          selectedDays: state.selectedDays,
          scheduleItems: state.scheduleItems,
          startDate: state.startDate,
          endDate: state.endDate,
          defaultStartTime: state.defaultStartTime,
          defaultEndTime: state.defaultEndTime,
          isEditMode: true,
          editingBatch: batch,
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
        isEditMode: true,
        editingBatch: batch,
      ),
    );

    final result = await _createBatchRepository.updateBatch(
      batchId: batch.id,
      data: payload,
    );

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
          isEditMode: true,
          editingBatch: batch,
        ),
      ),
      (response) => emit(
        CreateBatchSuccess(
          response: response,
          isUpdated: true,
          selectedDays: state.selectedDays,
          scheduleItems: state.scheduleItems,
          startDate: state.startDate,
          endDate: state.endDate,
          defaultStartTime: state.defaultStartTime,
          defaultEndTime: state.defaultEndTime,
          isEditMode: true,
          editingBatch: batch,
        ),
      ),
    );
  }

  void resetForm() {
    emit(const CreateBatchFormState());
  }
}
