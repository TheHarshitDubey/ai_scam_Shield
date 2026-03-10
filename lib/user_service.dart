import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {

  static String? userId;

  static Future<void> initUser() async {

    final prefs = await SharedPreferences.getInstance();

    String? storedId = prefs.getString("user_id");

    if (storedId == null) {

      var uuid = const Uuid();
      storedId = uuid.v4();

      await prefs.setString("user_id", storedId);

    }

    userId = storedId;
  }

}