import 'package:equatable/equatable.dart';

enum NavTab { home, batches, newBatch, profile }

/// Model representing a navigation item in the bottom bar
class NavItemModel extends Equatable {
  final NavTab tab;
  final String label;

  const NavItemModel({required this.tab, required this.label});

  @override
  List<Object?> get props => [tab, label];
}
