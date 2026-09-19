import 'package:fpdart/fpdart.dart';
import 'package:batch_management_app_direct/bloc-version/core/errors/failure.dart';
import '../datasources/edit_student_remote_data_source.dart';
import '../models/edit_student_model.dart';

class EditStudentRepository {
  final EditStudentRemoteDataSource _remoteDataSource;

  EditStudentRepository({required EditStudentRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  Future<Either<Failure, void>> updateStudent(
    String studentId,
    EditStudentRequestModel payload,
  ) async {
    try {
      final result = await _remoteDataSource.updateStudent(studentId, payload);

      if (result.isSuccess) {
        return const Right(null);
      }

      return Left(
        ServerFailure(result.errorMessage ?? 'Failed to update student.'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
