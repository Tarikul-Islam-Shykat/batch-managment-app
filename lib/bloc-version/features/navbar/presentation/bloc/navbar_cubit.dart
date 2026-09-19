import 'package:flutter_bloc/flutter_bloc.dart';
import 'navbar_state.dart';

class NavbarCubit extends Cubit<NavbarState> {
  NavbarCubit() : super(const NavbarState());

  void selectTab(int index) {
    if (state.currentIndex != index) {
      emit(state.copyWith(currentIndex: index));
    }
  }
}
