import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppManager {
  static AppManager _instance;

  AppManager._();

  static AppManager getInstance() {
    if (_instance == null) {
      _instance = AppManager._();
    }
    return _instance;
  }

  void init(BuildContext context) {
    /// 屏幕适配注册
    ScreenUtil.instance = ScreenUtil(width: 540, height: 810)..init(context);
  }
}
