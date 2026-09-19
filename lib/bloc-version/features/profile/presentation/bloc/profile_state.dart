import 'package:equatable/equatable.dart';
import '../../data/models/profile_model.dart';

abstract class ProfileState extends Equatable {
  final UserProfileModel? user;

  const ProfileState({this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading({super.user});
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(UserProfileModel user) : super(user: user);
}

class ProfileUpdating extends ProfileState {
  const ProfileUpdating(UserProfileModel user) : super(user: user);
}

class ProfileUpdateSuccess extends ProfileState {
  final String message;

  const ProfileUpdateSuccess({
    required UserProfileModel user,
    required this.message,
  }) : super(user: user);

  @override
  List<Object?> get props => [user, message];
}

class ProfileFailure extends ProfileState {
  final String errorMessage;

  const ProfileFailure({required this.errorMessage, super.user});

  @override
  List<Object?> get props => [errorMessage, user];
}

class ProfileLoggingOut extends ProfileState {
  const ProfileLoggingOut({super.user});
}

class ProfileLoggedOut extends ProfileState {
  const ProfileLoggedOut();
}
