import 'package:equatable/equatable.dart';
import '../../data/models/splash_model.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashAuthenticated extends SplashState {
  final SessionModel session;

  const SplashAuthenticated(this.session);

  @override
  List<Object?> get props => [session];
}

class SplashUnauthenticated extends SplashState {
  final String? message;

  const SplashUnauthenticated([this.message]);

  @override
  List<Object?> get props => [message];
}

class SplashMaintenance extends SplashState {
  final Map<String, dynamic> arguments;

  const SplashMaintenance(this.arguments);

  @override
  List<Object?> get props => [arguments];
}

class SplashUpdateRequired extends SplashState {
  final Map<String, dynamic> arguments;

  const SplashUpdateRequired(this.arguments);

  @override
  List<Object?> get props => [arguments];
}
