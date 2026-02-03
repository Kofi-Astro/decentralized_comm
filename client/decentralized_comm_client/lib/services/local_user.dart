import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class LocalUserService {
  static const _userIdKey = "user_id";
  static const _usernameKey = "username";

  // ####### LOCAL SERVICE OF USER ################
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, user.id);
    await prefs.setString(_usernameKey, user.username);
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(_userIdKey);
    final username = prefs.getString(_usernameKey);

    if (id == null || username == null) return null;

    return User(
      id: id,
      username: username,
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
