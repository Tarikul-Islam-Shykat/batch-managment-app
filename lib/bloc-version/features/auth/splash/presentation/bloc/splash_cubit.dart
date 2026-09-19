import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app_maintenance/data/repositories/app_status_gate_repository.dart';
import '../../data/repositories/splash_repository.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final SplashRepository _repository;
  final AppStatusGateRepository _gateRepository;

  SplashCubit(this._repository, this._gateRepository) : super(SplashInitial());

  /// Checks the version gate and user session after an initial branding duration
  Future<void> initSplash({Duration delay = const Duration(seconds: 2)}) async {
    emit(SplashLoading());

    // Minimum delay for branding display
    await Future.delayed(delay);

    // 1. Evaluate App Maintenance & Mandatory Version Update Gate
    try {
      final gateInfo = await _gateRepository.evaluateVersionGate();
      if (gateInfo != null) {
        if (gateInfo.shouldShowMaintenance) {
          emit(SplashMaintenance(gateInfo.toArguments()));
          return;
        }
        if (gateInfo.shouldUpdate) {
          emit(SplashUpdateRequired(gateInfo.toArguments()));
          return;
        }
      }
    } catch (_) {
      // If version gate check encounters network issues, proceed with session
    }

    // 2. Validate user session
    final result = await _repository.checkSession();
    result.fold(
      (failure) => emit(SplashUnauthenticated(failure.message)),
      (session) => emit(SplashAuthenticated(session)),
    );
  }
}
