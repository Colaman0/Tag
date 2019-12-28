import 'dart:io';

class ApiConstants {
  static final String RELEASE_URL = "https://m.hyqfx.com/";
  static final String TEST_URL = "http://test.hyqfx.com/";

  static final bool inProduction =
      const bool.fromEnvironment("dart.vm.product");

  // 首页url
  static final String MAIN_URL =
      "${TEST_URL}wechat/index.htm?device_type=${Platform.isAndroid ? "2" : "1"}&wktToken=";

//  static final String MAIN_URL = "http://10.0.0.35:777/?cid=10087585";

  /// 判断是否登录
  static final String CHECK_LOGIN = "auth/v1/checkLogin";

  /// app登录
  static final String LOGIN = "auth/v1/appLogin";
}
