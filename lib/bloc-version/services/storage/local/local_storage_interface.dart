abstract class ILocalStorageService {
  Future<void> write(String key, dynamic value);
  Future<dynamic> read(String key);
  Future<void> delete(String key);
  Future<void> clearAll();
  Future<bool> containsKey(String key);
}
