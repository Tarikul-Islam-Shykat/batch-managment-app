import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileCubit(this._profileRepository) : super(const ProfileInitial());

  /// Fetches the profile data
  Future<void> fetchProfile() async {
    emit(ProfileLoading(user: state.user));

    final result = await _profileRepository.getProfile();

    result.fold(
      (failure) =>
          emit(ProfileFailure(errorMessage: failure.message, user: state.user)),
      (user) => emit(ProfileLoaded(user)),
    );
  }

  /// Updates profile details
  Future<void> updateProfile(Map<String, dynamic> payload) async {
    if (payload.isEmpty) return;

    final currentUser = state.user;
    if (currentUser != null) {
      emit(ProfileUpdating(currentUser));
    }

    final result = await _profileRepository.updateProfile(payload);

    result.fold(
      (failure) => emit(
        ProfileFailure(errorMessage: failure.message, user: currentUser),
      ),
      (user) => emit(
        ProfileUpdateSuccess(
          user: user,
          message: 'Profile updated successfully.',
        ),
      ),
    );
  }

  /// Logs out user and clears session
  Future<void> logout() async {
    emit(ProfileLoggingOut(user: state.user));

    final result = await _profileRepository.logout();

    result.fold(
      (failure) =>
          emit(ProfileFailure(errorMessage: failure.message, user: state.user)),
      (_) => emit(const ProfileLoggedOut()),
    );
  }
}
