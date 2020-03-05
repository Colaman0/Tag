import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:tag/entity/BuildTagInfo.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/entity/TodoEntity.dart';
import 'package:tag/route/BuildFlagRoute.dart';
import 'package:tag/route/BuildTagRoute.dart';
import 'package:tag/route/EditTodoListRoute.dart';
import 'package:tag/route/FlagBackgroundRoute.dart';
import 'package:tag/route/LoginRoute.dart';
import 'package:tag/route/SelectDateRoute.dart';
import 'package:tag/route/SplashRoute.dart';
import 'package:tag/route/TagDetailRoute.dart';
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
    "/buildFlag": (BuildContext context) => BuildFlagRoute(),
    "/buildTag": (BuildContext context) => BuildTagRoute(),
    "/selectDate": (BuildContext context) => SelectDateRoute(),
    "/flagBg": (BuildContext context) => FlagBackgroundRoute(),
    "/editTodo": (BuildContext context) => EditTodoListRoute(),
    "/tag": (BuildContext context) => TagDetailRoute(),
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

  Future<Object> toBuildTag(BuildContext context, {BuildTagInfo buildTagInfo}) {
    if (buildTagInfo != null) {
      HashMap<String, dynamic> hashMap = HashMap();
      hashMap.putIfAbsent(Constants.DATA, () {
        return buildTagInfo;
      });
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      return Navigator.of(context)
          .pushNamed("/buildTag", arguments: hashMap)
          .whenComplete(() {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
      });
    } else {
      Navigator.of(context).pushNamed("/buildTag");
    }
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

  Future<Object> toEditTodoList(BuildContext context,
      {List<TodoEntity> todos}) {
    HashMap<String, dynamic> hashMap = HashMap();
    hashMap.putIfAbsent(Constants.DATA, () {
      return todos;
    });
    return Navigator.of(context).pushNamed("/editTodo", arguments: hashMap);
  }

  /// 跳转到Tag页面
  Future<Object> toTagRoute(BuildContext context, BuildTagInfo info) {
    HashMap<String, dynamic> hashMap = HashMap();
    hashMap.putIfAbsent(Constants.DATA, () {
      return info;
    });
    return Navigator.of(context).pushNamed("/tag", arguments: hashMap);
  }
}
