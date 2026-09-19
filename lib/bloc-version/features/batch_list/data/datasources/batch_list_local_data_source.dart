import 'package:batch_management_app_direct/bloc-version/services/storage/secure/secure_storage_interface.dart';
import 'package:batch_management_app_direct/bloc-version/services/storage/secure/keys.dart';

class BatchListLocalDataSource {
  final ISecureStorageService _secureStorage;

  BatchListLocalDataSource(this._secureStorage);

  Future<void> saveToken(String token) async {
    await _secureStorage.write(SecureKey.token, token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(SecureKey.token);
  }

  Future<void> clearUserData() async {
    await _secureStorage.clearAll();
  }
}
