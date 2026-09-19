import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/batch_list_repository.dart';
import 'batch_list_state.dart';

class BatchListCubit extends Cubit<BatchListState> {
  final BatchListRepository _batchListRepository;

  BatchListCubit(this._batchListRepository) : super(BatchListInitial());
}
