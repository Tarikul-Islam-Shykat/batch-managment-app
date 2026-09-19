import 'package:batch_management_app_direct/bloc-version/services/storage/secure/secure_storage_interface.dart';
import 'package:batch_management_app_direct/bloc-version/services/storage/secure/keys.dart';

class CreateBatchLocalDataSource {
  final ISecureStorageService _secureStorage;

  CreateBatchLocalDataSource(this._secureStorage);

  Future<String?> getToken() async {
    return await _secureStorage.read(SecureKey.token);
  }
}
