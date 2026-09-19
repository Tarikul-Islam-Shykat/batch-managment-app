import 'package:equatable/equatable.dart';

abstract class BatchListState extends Equatable {
  const BatchListState();

  @override
  List<Object?> get props => [];
}

class BatchListInitial extends BatchListState {}

class BatchListLoading extends BatchListState {}

class BatchListSuccess extends BatchListState {}

class BatchListFailure extends BatchListState {
  final String errorMessage;

  const BatchListFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
