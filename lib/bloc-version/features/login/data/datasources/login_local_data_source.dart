import 'package:batch_management_app_direct/bloc-version/services/storage/secure/keys.dart';
import 'package:batch_management_app_direct/bloc-version/services/storage/secure/secure_storage_interface.dart';

class LoginLocalDataSource {
  final ISecureStorageService _secureStorage;

  LoginLocalDataSource(this._secureStorage);

  Future<void> saveToken(String token) async {
    await _secureStorage.write(SecureKey.token, token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(SecureKey.token);
  }

  Future<void> saveRole(String role) async {
    await _secureStorage.write(SecureKey.role, role);
  }

  Future<String?> getRole() async {
    return await _secureStorage.read(SecureKey.role);
  }

  Future<void> clearUserData() async {
    await _secureStorage.delete(SecureKey.token);
    await _secureStorage.delete(SecureKey.role);
  }
}
