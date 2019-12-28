import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

///
/// * author : kyle
/// * time   : 2019/11/11
/// * desc   : 微信工具类
///
class WechatUtil {
  static const WX_ID = "wxef8acbe8eeb95c00";

  WechatUtil._();

  ///
  /// 初始化微信
  static void init() {
    fluwx.registerWxApi(appId: WX_ID);
  }

  ///
  /// 拉起微信登录
  ///
  static void requestLogin(Function(fluwx.WeChatAuthResponse) callback) {
    checkWechatInstall().then((onValue) {
      if (onValue) {
        fluwx.sendWeChatAuth(scope: "snsapi_userinfo", state: "wx_login");
        fluwx.responseFromAuth.listen(callback);
      }
    });
  }

  ///
  /// 调起微信支付
  ///
  static void requestPay(String orderInfo, Function(fluwx.WeChatPaymentResponse) callback) {
    checkWechatInstall().then((onValue) {
      if (onValue) {
        var orderMap = json.decode(orderInfo);
        fluwx.payWithWeChat(
            appId: WX_ID,
            partnerId: orderMap["partnerid"].toString(),
            prepayId: orderMap["prepay_id"].toString(),
            packageValue: orderMap["package"].toString(),
            nonceStr: orderMap["nonce_str"].toString(),
            timeStamp: int.parse(orderMap["timestamp"]),
            sign: orderMap["sign"].toString());
        fluwx.responseFromPayment.listen((response) {
          callback(response);
        });
      }
    });
  }

  static Future<bool> checkWechatInstall() async {
    bool isInstalled = await fluwx.isWeChatInstalled() as bool;
    if (!isInstalled) {
      Fluttertoast.showToast(msg: "没有检测到微信");
    }
    return isInstalled;
  }
}
