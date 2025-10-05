import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _key = 'reminders_v1';

  Future<void> saveRaw(String json) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, json);
  }

  Future<String?> loadRaw() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}
