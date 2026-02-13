import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class LocalUserService {
  static const _userIdKey = "user_id";
  static const _usernameKey = "username";

  // ####### LOCAL SERVICE OF USER ################
  static Future<void> saveUser(User user) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setInt(_userIdKey, user.id);
    await pref.setString(_usernameKey, user.username);
  }

  static Future<User?> getUser() async {
    final pref = await SharedPreferences.getInstance();
    final id = pref.getInt(_userIdKey);
    final username = pref.getString(_usernameKey);

    if (id == null || username == null) return null;

    return User(
      id: id,
      username: username,
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  static Future<void> clear() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}
