import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/core/widgets/app_snackbar.dart';

import 'bloc/batch_list_cubit.dart';
import 'bloc/batch_list_state.dart';

class BatchListView extends StatefulWidget {
  const BatchListView({super.key});

  @override
  State<BatchListView> createState() => _BatchListViewState();
}

class _BatchListViewState extends State<BatchListView> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BatchListCubit>(
      create: (context) => sl<BatchListCubit>(),
      child: BlocConsumer<BatchListCubit, BatchListState>(
        listener: (context, state) {
          if (state is BatchListFailure) {
            AppSnackbar.show(
              context: context,
              message: state.errorMessage,
              isSuccess: false,
            );
          } else if (state is BatchListSuccess) {
            AppSnackbar.show(
              context: context,
              message: 'BatchList Success!',
              isSuccess: true,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is BatchListLoading;

          return Scaffold(
            appBar: AppBar(title: const Text('BatchList')),
            body: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Input Field',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: const Text('Submit'),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
