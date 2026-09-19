import 'package:equatable/equatable.dart';

/// Base failure class representing application/network errors
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// Specific failure types
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection available.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to read/write local storage.']);
}
