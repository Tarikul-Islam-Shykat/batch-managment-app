import 'package:equatable/equatable.dart';
import '../../data/models/register_model.dart';

abstract class RegisterState extends Equatable {
  final bool isEmailValid;

  const RegisterState({this.isEmailValid = false});

  @override
  List<Object?> get props => [isEmailValid];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial({super.isEmailValid});
}

class RegisterLoading extends RegisterState {
  const RegisterLoading({super.isEmailValid});
}

class RegisterSuccess extends RegisterState {
  final RegisterResponseModel response;

  const RegisterSuccess(this.response, {super.isEmailValid});

  @override
  List<Object?> get props => [response, isEmailValid];
}

class RegisterFailure extends RegisterState {
  final String errorMessage;

  const RegisterFailure(this.errorMessage, {super.isEmailValid});

  @override
  List<Object?> get props => [errorMessage, isEmailValid];
}

class RegisterValidationError extends RegisterState {
  final String message;

  const RegisterValidationError(this.message, {super.isEmailValid});

  @override
  List<Object?> get props => [message, isEmailValid];
}
