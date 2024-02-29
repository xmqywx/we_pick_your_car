import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  // static setData(String key, dynamic value) async {
  //   var prefs = await SharedPreferences.getInstance();
  //   prefs.setString(key, json.encode(value));
  // }

  static Future<void> setData(String key, dynamic value, {int? expires}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, json.encode(value));
    if (expires != null) {
      // 设置过期时间，当前时间 + expires秒
      print("========= expire $expires ${key}_expire");
      int expireTime = DateTime.now().millisecondsSinceEpoch + expires * 1000;
      await prefs.setInt('${key}_expire', expireTime);
    }
  }

  static getData(String key) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String? tempData = prefs.getString(key);
      if (tempData != null) {
        return json.decode(tempData);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static removeData(String key) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static clear(String key) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future<bool> isExpired(String key) async {
    final prefs = await SharedPreferences.getInstance();
    int? expireTime = prefs.getInt('${key}_expire');
    print('${key}_expire $expireTime');
    if (expireTime == null) return false; // 没有设置过期时间，认为不过期
    print(DateTime.now().millisecondsSinceEpoch);
    print(expireTime);
    return DateTime.now().millisecondsSinceEpoch > expireTime;
  }
}
