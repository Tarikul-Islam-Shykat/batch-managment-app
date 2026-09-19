import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/repositories/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit({required HomeRepository repository})
    : _repository = repository,
      super(const HomeState()) {
    _initializeMonths();
  }

  void _initializeMonths() {
    final now = DateTime.now();
    final current = DateFormat('MMMM yyyy', 'en_US').format(now);
    final options = <String>[];

    for (int offset = -6; offset <= 6; offset++) {
      final date = DateTime(now.year, now.month + offset);
      options.add(DateFormat('MMMM yyyy', 'en_US').format(date));
    }

    final uniqueOptions = options.toSet().toList();
    final initialMonth = uniqueOptions.contains(current)
        ? current
        : (uniqueOptions.isNotEmpty ? uniqueOptions.first : current);

    emit(
      state.copyWith(selectedMonth: initialMonth, monthOptions: uniqueOptions),
    );
  }

  Future<void> fetchDashboard() async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: null));

    final result = await _repository.getTeacherDashboard(
      month: state.selectedMonth,
      recentLimit: state.recentLimit,
      lowSeatThreshold: state.lowSeatThreshold,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (dashboard) => emit(
        state.copyWith(status: HomeStatus.success, dashboard: dashboard),
      ),
    );
  }

  Future<void> changeMonth(String month) async {
    if (month.trim().isEmpty || state.selectedMonth == month) return;

    emit(state.copyWith(selectedMonth: month));
    await fetchDashboard();
  }

  Future<void> refresh() async {
    await fetchDashboard();
  }
}
