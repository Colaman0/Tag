import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tag/entity/BuildFlagInfo.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/route/FlagBackgroundRoute.dart';
import 'package:tag/util/NaigatorUtils.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/View.dart';

/// Flag详情页面
class FlagDetailRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> childs = getFlagContentWidgets(getInitInfo(context));
    childs.add(getAppbar(context));
    return Material(
      child: Builder(
        builder: (context) {
          return Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: childs,
          );
        },
      ),
    );
  }

  /// 获取初始化的info
  BuildFlagInfo getInitInfo(BuildContext context) {
    if (NavigatorUtils.getPreArguments(context) != null) {
      return NavigatorUtils.getPreArguments(context)[Constants.DATA];
    }
  }

  /// 顶部标题栏
  Widget getAppbar(BuildContext context) {
    return Positioned(
      top: ScreenUtil.statusBarHeight,
      left: 0,
      right: 0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          View(
              child: Icon(
            Icons.arrow_back,
            size: DP.toDouble(36),
            color: Colors.white,
          )).padding(both: 16).circle().click(() {
            Navigator.pop(context);
          }),
          Spacer(),
          View(
              child: Icon(
            Icons.brightness_medium,
            size: DP.toDouble(36),
            color: Colors.white,
          )).padding(both: 16).circle().click(() {
            Navigator.pop(context);

            /// 跳转到Flag页面
            NavigatorUtils.getInstance()
                .toBuildFlag(context, info: getInitInfo(context));
          }),
        ],
      ),
    );
  }
}
