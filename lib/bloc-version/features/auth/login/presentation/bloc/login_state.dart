import 'package:equatable/equatable.dart';
import '../../data/models/login_model.dart';

abstract class LoginState extends Equatable {
  final bool isEmailValid;

  const LoginState({this.isEmailValid = false});

  @override
  List<Object?> get props => [isEmailValid];
}

class LoginInitial extends LoginState {
  const LoginInitial({super.isEmailValid});
}

class LoginLoading extends LoginState {
  const LoginLoading({super.isEmailValid});
}

class LoginSuccess extends LoginState {
  final LoginResponseModel response;

  const LoginSuccess(this.response, {super.isEmailValid});

  @override
  List<Object?> get props => [response, isEmailValid];
}

class LoginFailure extends LoginState {
  final String errorMessage;

  const LoginFailure(this.errorMessage, {super.isEmailValid});

  @override
  List<Object?> get props => [errorMessage, isEmailValid];
}

class LoginValidationError extends LoginState {
  final String message;

  const LoginValidationError(this.message, {super.isEmailValid});

  @override
  List<Object?> get props => [message, isEmailValid];
}
