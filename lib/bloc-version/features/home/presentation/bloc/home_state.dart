import 'package:equatable/equatable.dart';
import '../../data/models/home_dashboard_model.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final HomeDashboardModel? dashboard;
  final String selectedMonth;
  final List<String> monthOptions;
  final int recentLimit;
  final int lowSeatThreshold;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.dashboard,
    this.selectedMonth = '',
    this.monthOptions = const [],
    this.recentLimit = 5,
    this.lowSeatThreshold = 3,
    this.errorMessage,
  });

  bool get isLoading => status == HomeStatus.loading;
  bool get hasError => status == HomeStatus.failure;
  bool get hasData => dashboard != null;

  HomeState copyWith({
    HomeStatus? status,
    HomeDashboardModel? dashboard,
    String? selectedMonth,
    List<String>? monthOptions,
    int? recentLimit,
    int? lowSeatThreshold,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      dashboard: dashboard ?? this.dashboard,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      monthOptions: monthOptions ?? this.monthOptions,
      recentLimit: recentLimit ?? this.recentLimit,
      lowSeatThreshold: lowSeatThreshold ?? this.lowSeatThreshold,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    dashboard,
    selectedMonth,
    monthOptions,
    recentLimit,
    lowSeatThreshold,
    errorMessage,
  ];
}
