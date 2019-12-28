import 'dart:convert';

import 'package:tag/entity/UserInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// * author : kyle
/// * time   : 2019/11/14
/// * desc   : 用户信息管理类
///

class UserManager {
  static String _loginInfo = "userinfo_key";
  static UserManager _instance;
  LoginInfo _userInfo;

  UserManager._();

  static UserManager getInstance() {
    if (_instance == null) {
      _instance = UserManager._();
    }
    return _instance;
  }

  /// 把用户信息保存到本地
  Future<void> putLoginInfo(LoginInfo info) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_loginInfo, json.encode(info.toJson()));
  }

  /// 获取本地用户信息
  Future<LoginInfo> getLocalUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    // 获取缓存str
    String jsonStr = prefs.getString(_loginInfo);
    if (jsonStr == null || jsonStr.isEmpty) {
      return _userInfo;
    }
    _userInfo = LoginInfo.fromJsonMap(JsonDecoder().convert(prefs.getString(_loginInfo) ?? ""));
    return _userInfo;
  }

  void reset() {
    _userInfo = null;
  }
}
