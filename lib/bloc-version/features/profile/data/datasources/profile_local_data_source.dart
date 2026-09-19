import 'package:batch_management_app_direct/bloc-version/services/storage/secure/secure_storage_interface.dart';
import 'package:batch_management_app_direct/bloc-version/services/storage/secure/keys.dart';

class ProfileLocalDataSource {
  final ISecureStorageService _secureStorage;

  ProfileLocalDataSource(this._secureStorage);

  Future<String?> getToken() async {
    return await _secureStorage.read(SecureKey.token);
  }

  Future<String?> getRole() async {
    return await _secureStorage.read(SecureKey.role);
  }

  Future<void> saveRole(String role) async {
    await _secureStorage.write(SecureKey.role, role);
  }

  Future<void> clearUserData() async {
    await _secureStorage.clearAll();
  }
}
