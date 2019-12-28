import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tag/view/widget/view/View.dart';

///
/// * Author    : kyle
/// * Time      : 2019/9/9
/// * Function  : 存放工具方法
///

class DP {
  static double get(int dp) {
    if (dp == null || dp == 0.0 || dp == View.WRAP) {
      return 0.0;
    }
    if (dp == View.MATCH) {
      return double.infinity;
    }
    return ScreenUtil.getInstance().setWidth(dp.toDouble());
  }
}

class SP {
  static double get(int dp) {
    if (dp == null) {
      return 0;
    }
    return ScreenUtil.getInstance().setSp(dp.toDouble());
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

///  padding 处理
class CustomMP {
  var both, left, right, top, bottom = 0;

  CustomMP({this.both, this.left, this.right, this.top, this.bottom});

  EdgeInsets getParams() {
    return EdgeInsets.only(
        left: getFinalValue(left), right: getFinalValue(right), top: getFinalValue(top), bottom: getFinalValue(bottom));
  }

  /// 如果传入的padding = 0 ，则使用默认的padding
  double getFinalValue(int value) {
    return DP.get((value == null || value == 0) ? this.both : value);
  }
}
