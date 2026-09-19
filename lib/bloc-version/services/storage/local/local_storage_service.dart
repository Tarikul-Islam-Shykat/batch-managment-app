import 'package:shared_preferences/shared_preferences.dart';
import 'local_storage_interface.dart';

class LocalStorageService implements ILocalStorageService {
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();

  @override
  Future<void> write(String key, dynamic value) async {
    final prefs = await _instance;
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    }
  }

  @override
  Future<dynamic> read(String key) async {
    final prefs = await _instance;
    return prefs.get(key);
  }

  @override
  Future<void> delete(String key) async {
    final prefs = await _instance;
    await prefs.remove(key);
  }

  @override
  Future<void> clearAll() async {
    final prefs = await _instance;
    await prefs.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    final prefs = await _instance;
    return prefs.containsKey(key);
  }
}
