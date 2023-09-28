import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/helpers/logger.dart';

class LocalUser extends InheritedWidget {
  LocalUser({super.key, required this.child}) : super(child: child);

  final Future<SharedPreferences> _localStore = SharedPreferences.getInstance();

  Future<void> setUser(UserProfile user) async {
    try {
      (await _localStore).setString('local_user', json.encode(user.toJson()));
    } catch (e) {
      verifiedErrorLogger(e);
    }
  }

  Future<UserProfile?> getUser() async {
    try {
      String? user = (await _localStore).getString('local_user');
      if (user == null) return null;
      return UserProfile.fromJson(json.decode(user));
    } catch (e) {
      verifiedErrorLogger(e);
      return null;
    }
  }

  @override
  // ignore: overridden_fields
  final Widget child;

  static LocalUser? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LocalUser>();
  }

  @override
  bool updateShouldNotify(LocalUser oldWidget) {
    return true;
  }
}
