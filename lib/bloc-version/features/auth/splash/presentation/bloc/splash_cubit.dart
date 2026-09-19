import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/splash_repository.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final SplashRepository _repository;

  SplashCubit(this._repository) : super(SplashInitial());

  /// Checks the user session after an initial branding duration
  Future<void> initSplash({Duration delay = const Duration(seconds: 2)}) async {
    emit(SplashLoading());

    // Minimum delay for branding display
    await Future.delayed(delay);

    final result = await _repository.checkSession();
    result.fold(
      (failure) => emit(SplashUnauthenticated(failure.message)),
      (session) => emit(SplashAuthenticated(session)),
    );
  }
}
