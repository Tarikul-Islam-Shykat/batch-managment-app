import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/register_repository.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepository _registerRepository;

  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  RegisterCubit(this._registerRepository) : super(const RegisterInitial());

  /// Real-time validation of email
  void onEmailChanged(String email) {
    final trimmed = email.trim();
    final isValid = trimmed.isNotEmpty && _emailRegex.hasMatch(trimmed);

    if (state.isEmailValid != isValid) {
      if (state is RegisterLoading) return;
      emit(RegisterInitial(isEmailValid: isValid));
    }
  }

  /// Perform register validation & submission
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final trimmedName = name.trim();
    final trimmedEmail = email.trim();

    if (trimmedName.isEmpty) {
      emit(
        RegisterValidationError(
          'Please enter your name.',
          isEmailValid: state.isEmailValid,
        ),
      );
      return;
    }

    if (trimmedEmail.isEmpty) {
      emit(
        const RegisterValidationError(
          'Please enter your email address.',
          isEmailValid: false,
        ),
      );
      return;
    }

    if (!_emailRegex.hasMatch(trimmedEmail)) {
      emit(
        const RegisterValidationError(
          'Please enter a valid email address.',
          isEmailValid: false,
        ),
      );
      return;
    }

    if (password.isEmpty) {
      emit(
        RegisterValidationError(
          'Please enter your password.',
          isEmailValid: state.isEmailValid,
        ),
      );
      return;
    }

    if (confirmPassword.isEmpty) {
      emit(
        RegisterValidationError(
          'Please confirm your password.',
          isEmailValid: state.isEmailValid,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      emit(
        RegisterValidationError(
          'Passwords do not match.',
          isEmailValid: state.isEmailValid,
        ),
      );
      return;
    }

    emit(RegisterLoading(isEmailValid: state.isEmailValid));

    final result = await _registerRepository.signUp(
      name: trimmedName,
      email: trimmedEmail,
      password: password,
    );

    result.fold(
      (failure) => emit(
        RegisterFailure(failure.message, isEmailValid: state.isEmailValid),
      ),
      (response) =>
          emit(RegisterSuccess(response, isEmailValid: state.isEmailValid)),
    );
  }
}
