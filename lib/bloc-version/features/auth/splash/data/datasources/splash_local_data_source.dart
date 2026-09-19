import 'package:batch_management_app_direct/bloc-version/services/storage/secure/keys.dart';
import 'package:batch_management_app_direct/bloc-version/services/storage/secure/secure_storage_interface.dart';

class SplashLocalDataSource {
  final ISecureStorageService _secureStorage;

  SplashLocalDataSource(this._secureStorage);

  Future<String?> getToken() async {
    return await _secureStorage.read(SecureKey.token);
  }

  Future<String?> getRole() async {
    return await _secureStorage.read(SecureKey.role);
  }

  Future<void> saveRole(String role) async {
    await _secureStorage.write(SecureKey.role, role);
  }

  Future<void> clearSession() async {
    await _secureStorage.delete(SecureKey.token);
    await _secureStorage.delete(SecureKey.role);
  }
}
