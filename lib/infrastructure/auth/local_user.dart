import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/helpers/logger.dart';

class LocalUser {
  static final Future<SharedPreferences> _localStore = SharedPreferences.getInstance();

  static Future<void> clearUser() async {
    try {
      final pref = await _localStore;
      await pref.setString(
        'local_user',
        '',
      );
    } catch (e) {
      verifiedErrorLogger(e);
    }
  }

  static Future<void> setUser(UserProfile user) async {
    try {
      final pref = await _localStore;
      await pref.setString(
        'local_user',
        json.encode(user.toJson()),
      );
    } catch (e) {
      verifiedErrorLogger(e);
    }
  }

  static Future<UserProfile?> getUser() async {
    try {
      final pref = await _localStore;
      String? user = pref.getString('local_user');
      print("GET STORED USER ${pref.getString('local_user')}");
      if (user == null) return null;
      return UserProfile.fromJson(json.decode(user));
    } catch (e) {
      verifiedErrorLogger(e);
      return null;
    }
  }
}
