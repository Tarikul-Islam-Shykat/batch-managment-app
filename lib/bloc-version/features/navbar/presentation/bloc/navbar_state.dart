import 'package:equatable/equatable.dart';

class NavbarState extends Equatable {
  final int currentIndex;

  const NavbarState({this.currentIndex = 0});

  NavbarState copyWith({int? currentIndex}) {
    return NavbarState(currentIndex: currentIndex ?? this.currentIndex);
  }

  @override
  List<Object?> get props => [currentIndex];
}
