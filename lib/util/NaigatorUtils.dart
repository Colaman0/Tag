import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:tag/route/BuildFlagRoute.dart';
import 'package:tag/route/BuildTagRoute.dart';
import 'package:tag/route/FlagBackgroundRoute.dart';
import 'package:tag/route/LoginRoute.dart';
import 'package:tag/route/SelectDateRoute.dart';
import 'package:tag/route/SplashRoute.dart';
import 'package:tag/route/main/MainPage.dart';

///
/// * author : kyle
/// * time   : 2019/11/15
/// * desc   : 页面路由工具类
///

class NavigatorUtils {
  static NavigatorUtils _instance;

  static Map<String, WidgetBuilder> routeMap = {
    "/": (BuildContext context) => SplashRoute(),
    "/login": (BuildContext context) => LoginRoute(),
    "/main": (BuildContext context) => MainPage(),
    "/buildFlag": (BuildContext context) => BuildTagRoute(
          buildType: BuildTagRoute.FLAG,
        ),
    "/buildTag": (BuildContext context) => BuildTagRoute(
          buildType: BuildTagRoute.TAG,
        ),
    "/selectDate": (BuildContext context) => SelectDateRoute(),
    "/flagBg": (BuildContext context) => FlagBackgroundRoute(),
  };

  NavigatorUtils._();

  static NavigatorUtils getInstance() {
    if (_instance == null) {
      _instance = NavigatorUtils._();
    }
    return _instance;
  }

  static Map<String, dynamic> getPreArguments(BuildContext context) {
    return ModalRoute.of(context).settings.arguments;
  }

  /// 跳转到登录页面，并且清空其他路由
  void toLogin(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  /// 跳转到主页面，并且清空其他路由
  void toMain(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false);
  }

  void toBuildFlag(BuildContext context) {
    Navigator.of(context).pushNamed("/buildFlag");
  }

  void toBuildTag(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    Navigator.of(context).pushNamed("/buildTag").whenComplete(() {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    });
  }

  Future<Object> toSelectDate(BuildContext context, DateTime dateTime) {
    HashMap<String, dynamic> hashMap = HashMap();
    hashMap.putIfAbsent(SelectDateRoute.CREATE_DATE, () {
      return dateTime;
    });
    return Navigator.of(context).pushNamed("/selectDate", arguments: hashMap);
  }

  void toFlagBg(BuildContext context, String name, DateTime time) {
    HashMap<String, dynamic> hashMap = HashMap();
    hashMap.putIfAbsent(FlagBackgroundRoute.FLAG_NAME, () {
      return name;
    });
    hashMap.putIfAbsent(FlagBackgroundRoute.FLAG_DATE, () {
      return time;
    });
    Navigator.of(context).pushNamed("/flagBg", arguments: hashMap);
  }
}
