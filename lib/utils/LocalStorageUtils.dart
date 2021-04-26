import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageUtils {
  static Future<void> setString(String key, String value) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    await storage.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    return storage.getString(key);
  }

  static Future<void> setBool(String key, bool value) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    await storage.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    return storage.getBool(key);
  }

  static Future<void> removeKey(String key) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    await storage.remove(key);
  }
}
