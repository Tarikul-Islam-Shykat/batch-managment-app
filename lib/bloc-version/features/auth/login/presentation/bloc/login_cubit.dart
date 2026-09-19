import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/login_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository _loginRepository;

  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  LoginCubit(this._loginRepository) : super(const LoginInitial());

  /// Real-time validation of email to update green tick
  void onEmailChanged(String email) {
    final trimmed = email.trim();
    final isValid = trimmed.isNotEmpty && _emailRegex.hasMatch(trimmed);

    if (state.isEmailValid != isValid) {
      if (state is LoginLoading) return;
      emit(LoginInitial(isEmailValid: isValid));
    }
  }

  /// Perform login validation & request
  Future<void> login({required String email, required String password}) async {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty && password.isEmpty) {
      emit(
        const LoginValidationError(
          'Please enter email and password.',
          isEmailValid: false,
        ),
      );
      return;
    }

    if (trimmedEmail.isEmpty) {
      emit(
        const LoginValidationError(
          'Please enter your email address.',
          isEmailValid: false,
        ),
      );
      return;
    }

    if (!_emailRegex.hasMatch(trimmedEmail)) {
      emit(
        const LoginValidationError(
          'Please enter a valid email address.',
          isEmailValid: false,
        ),
      );
      return;
    }

    if (password.isEmpty) {
      emit(
        const LoginValidationError(
          'Please enter your password.',
          isEmailValid: true,
        ),
      );
      return;
    }

    emit(const LoginLoading(isEmailValid: true));

    final result = await _loginRepository.login(
      email: trimmedEmail,
      password: password,
    );

    result.fold(
      (failure) => emit(LoginFailure(failure.message, isEmailValid: true)),
      (response) => emit(LoginSuccess(response, isEmailValid: true)),
    );
  }
}
