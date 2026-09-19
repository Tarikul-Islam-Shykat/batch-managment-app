import 'package:batch_management_app_direct/bloc-version/services/storage/secure/secure_storage_interface.dart';
import 'package:batch_management_app_direct/bloc-version/services/storage/secure/keys.dart';

class OtpVerificationLocalDataSource {
  final ISecureStorageService _secureStorage;

  OtpVerificationLocalDataSource(this._secureStorage);

  Future<void> saveToken(String token) async {
    await _secureStorage.write(SecureKey.token, token);
  }

  Future<void> saveRole(String role) async {
    await _secureStorage.write(SecureKey.role, role);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(SecureKey.token);
  }

  Future<String?> getRole() async {
    return await _secureStorage.read(SecureKey.role);
  }

  Future<void> clearUserData() async {
    await _secureStorage.clearAll();
  }
}
