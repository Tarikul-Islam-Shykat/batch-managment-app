import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/service/network/endpoints/endpoints.dart';
import '../../../../core/service/network/service/api_service.dart';
import '../model/create_batch_request_model.dart';

String formatTime12h(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hour:$minute $period';
}

class DayOption {
  final String label;
  final String value;

  const DayOption({required this.label, required this.value});
}

class DayScheduleItem {
  final String day;
  final TextEditingController startController;
  final TextEditingController endController;
  TimeOfDay startTime;
  TimeOfDay endTime;

  DayScheduleItem({
    required this.day,
    required this.startTime,
    required this.endTime,
  }) : startController = TextEditingController(),
       endController = TextEditingController();

  void dispose() {
    startController.dispose();
    endController.dispose();
  }
}

class CreateBatchController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final batchNameController = TextEditingController();
  final subjectController = TextEditingController();
  final feesController = TextEditingController();
  final maxStudentsController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final defaultStartTimeController = TextEditingController(
    text: formatTime12h(const TimeOfDay(hour: 18, minute: 0)),
  );
  final defaultEndTimeController = TextEditingController(
    text: formatTime12h(const TimeOfDay(hour: 20, minute: 0)),
  );

  final isLoading = false.obs;
  final selectedDays = <String>[].obs;
  final scheduleItems = <DayScheduleItem>[].obs;
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final defaultStartTime = const TimeOfDay(hour: 18, minute: 0).obs;
  final defaultEndTime = const TimeOfDay(hour: 20, minute: 0).obs;

  final _api = ApiService.instance;

  List<DayOption> get days => [
    DayOption(label: 'day_saturday'.tr, value: 'Saturday'),
    DayOption(label: 'day_sunday'.tr, value: 'Sunday'),
    DayOption(label: 'day_monday'.tr, value: 'Monday'),
    DayOption(label: 'day_tuesday'.tr, value: 'Tuesday'),
    DayOption(label: 'day_wednesday'.tr, value: 'Wednesday'),
    DayOption(label: 'day_thursday'.tr, value: 'Thursday'),
    DayOption(label: 'day_friday'.tr, value: 'Friday'),
  ];

  void toggleDay(String day) {
    final index = scheduleItems.indexWhere((item) => item.day == day);
    if (index >= 0) {
      scheduleItems[index].dispose();
      scheduleItems.removeAt(index);
      selectedDays.remove(day);
      return;
    }

    final item = DayScheduleItem(
      day: day,
      startTime: defaultStartTime.value,
      endTime: defaultEndTime.value,
    );
    _syncItemText(item);
    scheduleItems.add(item);
    selectedDays.add(day);
  }

  bool get hasSelectedDays => selectedDays.isNotEmpty;

  String displayDayLabel(String day) {
    switch (day) {
      case 'Saturday':
        return 'day_saturday'.tr;
      case 'Sunday':
        return 'day_sunday'.tr;
      case 'Monday':
        return 'day_monday'.tr;
      case 'Tuesday':
        return 'day_tuesday'.tr;
      case 'Wednesday':
        return 'day_wednesday'.tr;
      case 'Thursday':
        return 'day_thursday'.tr;
      case 'Friday':
        return 'day_friday'.tr;
      default:
        return day;
    }
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '${date.year}-$m-$d';
  }

  String _formatTime24(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _syncItemText(DayScheduleItem item) {
    item.startController.text = formatTime12h(item.startTime);
    item.endController.text = formatTime12h(item.endTime);
  }

  void _syncDefaultControllers() {
    defaultStartTimeController.text = formatTime12h(defaultStartTime.value);
    defaultEndTimeController.text = formatTime12h(defaultEndTime.value);
  }

  Future<DateTime?> _showDateDialog(
    BuildContext context, {
    required String title,
    required DateTime initialDate,
    required DateTime firstDate,
  }) {
    DateTime selectedDate = initialDate;

    return showDialog<DateTime>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(title),
          contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          content: SizedBox(
            width: double.maxFinite,
            child: StatefulBuilder(
              builder: (context, setState) {
                return CalendarDatePicker(
                  initialDate: selectedDate,
                  firstDate: firstDate,
                  lastDate: DateTime(2100),
                  onDateChanged: (date) {
                    setState(() => selectedDate = date);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('cancel'.tr),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(selectedDate),
              child: Text('select'.tr),
            ),
          ],
        );
      },
    );
  }

  Future<TimeOfDay?> _showTimeDialog(
    BuildContext context, {
    required String title,
    required TimeOfDay initialTime,
  }) {
    return showDialog<TimeOfDay>(
      context: context,
      builder: (dialogContext) {
        return MediaQuery(
          data: MediaQuery.of(
            dialogContext,
          ).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: Theme.of(dialogContext).copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Get.theme.colorScheme.primary,
              ),
              timePickerTheme: TimePickerThemeData(
                dialHandColor: Get.theme.colorScheme.primary,
                dayPeriodBorderSide: BorderSide(
                  color: Get.theme.colorScheme.primary,
                ),
              ),
            ),
            child: TimePickerDialog(
              initialTime: initialTime,
              helpText: title,
              confirmText: 'select'.tr,
              cancelText: 'cancel'.tr,
              hourLabelText: 'hour'.tr,
              minuteLabelText: 'minute'.tr,
            ),
          ),
        );
      },
    );
  }

  Future<void> pickStartDate(BuildContext context) async {
    final picked = await _showDateDialog(
      context,
      title: 'select_start_date'.tr,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
    );
    if (picked != null) {
      startDate.value = picked;
      startDateController.text = _formatDate(picked);
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final picked = await _showDateDialog(
      context,
      title: 'select_end_date'.tr,
      initialDate: endDate.value ?? startDate.value ?? DateTime.now(),
      firstDate: startDate.value ?? DateTime.now(),
    );
    if (picked != null) {
      endDate.value = picked;
      endDateController.text = _formatDate(picked);
    }
  }

  Future<void> pickDefaultStartTime(BuildContext context) async {
    final picked = await _showTimeDialog(
      context,
      title: 'select_default_start_time'.tr,
      initialTime: defaultStartTime.value,
    );
    if (picked != null) {
      defaultStartTime.value = picked;
      _syncDefaultControllers();
    }
  }

  Future<void> pickDefaultEndTime(BuildContext context) async {
    final picked = await _showTimeDialog(
      context,
      title: 'select_default_end_time'.tr,
      initialTime: defaultEndTime.value,
    );
    if (picked != null) {
      defaultEndTime.value = picked;
      _syncDefaultControllers();
    }
  }

  Future<void> pickScheduleStartTime(BuildContext context, int index) async {
    final item = scheduleItems[index];
    final picked = await _showTimeDialog(
      context,
      title: 'select_start_time_for_day'.tr.replaceAll(
        '{day}',
        displayDayLabel(item.day),
      ),
      initialTime: item.startTime,
    );
    if (picked != null) {
      item.startTime = picked;
      _syncItemText(item);
      scheduleItems.refresh();
    }
  }

  Future<void> pickScheduleEndTime(BuildContext context, int index) async {
    final item = scheduleItems[index];
    final picked = await _showTimeDialog(
      context,
      title: 'select_end_time_for_day'.tr.replaceAll(
        '{day}',
        displayDayLabel(item.day),
      ),
      initialTime: item.endTime,
    );
    if (picked != null) {
      item.endTime = picked;
      _syncItemText(item);
      scheduleItems.refresh();
    }
  }

  void applyDefaultTimeToAll() {
    for (final item in scheduleItems) {
      item.startTime = defaultStartTime.value;
      item.endTime = defaultEndTime.value;
      _syncItemText(item);
    }
    scheduleItems.refresh();
  }

  void applyDefaultTimeToItem(int index) {
    final item = scheduleItems[index];
    item.startTime = defaultStartTime.value;
    item.endTime = defaultEndTime.value;
    _syncItemText(item);
    scheduleItems.refresh();
  }

  Future<void> createBatch() async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      Get.snackbar(
        'missing_fields'.tr,
        'fill_required_fields'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedDays.isEmpty ||
        startDate.value == null ||
        endDate.value == null) {
      Get.snackbar(
        'missing_fields'.tr,
        'select_days_and_dates'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (scheduleItems.length != selectedDays.length) {
      Get.snackbar(
        'missing_schedule'.tr,
        'complete_schedule'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final fees = int.tryParse(feesController.text.trim());
    final maxStudents = int.tryParse(maxStudentsController.text.trim());

    if (fees == null || maxStudents == null) {
      Get.snackbar(
        'invalid_input'.tr,
        'fees_and_max_must_be_numbers'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final payload = CreateBatchRequestModel(
      batchName: batchNameController.text.trim(),
      subject: subjectController.text.trim(),
      startDate: _formatDate(startDate.value!),
      endDate: _formatDate(endDate.value!),
      fees: fees,
      maxStudents: maxStudents,
      schedule: scheduleItems
          .map(
            (item) => BatchScheduleModel(
              day: item.day,
              startTime: _formatTime24(item.startTime),
              endTime: _formatTime24(item.endTime),
            ),
          )
          .toList(),
    );

    try {
      isLoading.value = true;
      final response = await _api.post(Urls.createBatch, payload.toJson());

      if (response != null) {
        Get.snackbar(
          'success'.tr,
          'batch_created_successfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        clearForm();
      } else {
        Get.snackbar(
          'failed'.tr,
          'batch_creation_failed'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'failed'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    batchNameController.clear();
    subjectController.clear();
    feesController.clear();
    maxStudentsController.clear();
    startDate.value = null;
    endDate.value = null;
    startDateController.clear();
    endDateController.clear();
    defaultStartTime.value = const TimeOfDay(hour: 18, minute: 0);
    defaultEndTime.value = const TimeOfDay(hour: 20, minute: 0);
    _syncDefaultControllers();
    for (final item in scheduleItems) {
      item.dispose();
    }
    scheduleItems.clear();
    selectedDays.clear();
  }

  @override
  void onClose() {
    batchNameController.dispose();
    subjectController.dispose();
    feesController.dispose();
    maxStudentsController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    defaultStartTimeController.dispose();
    defaultEndTimeController.dispose();
    for (final item in scheduleItems) {
      item.dispose();
    }
    super.onClose();
  }
}
