import '../datasources/navbar_local_data_source.dart';
import '../datasources/navbar_remote_data_source.dart';

class NavbarRepository {
  final NavbarLocalDataSource localDataSource;
  final NavbarRemoteDataSource remoteDataSource;

  NavbarRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });
}
