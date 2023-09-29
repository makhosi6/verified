import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/helpers/logger.dart';

class LocalUser {
  static final Future<SharedPreferences> _localStore = SharedPreferences.getInstance();

  static Future<void> setUser(UserProfile user) async {
    try {
      (await _localStore).setString('local_user', json.encode(user.toJson()));
    } catch (e) {
      verifiedErrorLogger(e);
    }
  }

  static Future<UserProfile?> getUser() async {
    try {
      String? user = (await _localStore).getString('local_user');
      if (user == null) return null;
      return UserProfile.fromJson(json.decode(user));
    } catch (e) {
      verifiedErrorLogger(e);
      return null;
    }
  }
}
