import 'package:flutter/material.dart';
import 'package:tag/entity/UserInfo.dart';
import 'package:tag/util/AppManager.dart';
import 'package:tag/util/NaigatorUtils.dart';
import 'package:tag/util/UserManager.dart';
import 'package:tag/view/widget/view/TextView.dart';

class SplashRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppManager.getInstance().init(context);
    checkLoginStatus(context);

    return MaterialApp(
      home: Center(
        child: Icon(Icons.loyalty),
      ),
    );
  }

  /// 检查登录状态
  void checkLoginStatus(BuildContext context) async {
    LoginInfo info = await UserManager.getInstance().getLocalUserInfo();
    if (info == null) {
      NavigatorUtils.getInstance().toMain(context);
    } else {
      NavigatorUtils.getInstance().toMain(context);
    }
  }
}
