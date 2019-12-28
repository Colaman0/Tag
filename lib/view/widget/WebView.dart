import 'dart:io';

import 'package:tag/util/DoubleClickUtil.dart';
import 'package:tag/util/NaigatorUtils.dart';
import 'package:tag/util/WechatUtil.dart';
import 'package:tag/view/widget/BaseWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

import 'view/TextView.dart';

///
/// * author : kyle
/// * time   : 2019/11/14
/// * desc   : webview
///

class CustomWebView extends StatefulWidget {
  String url;

  CustomWebView({String this.url, Key key}) : super(key: key) {}

  @override
  _CustomWebViewState createState() => _CustomWebViewState(url);
}

class _CustomWebViewState extends State<CustomWebView> {
  String url = "";
  WebviewScaffold webView;

  /// 双击监听
  DoubleClickUtil doubleClickUtil = DoubleClickUtil();

  /// webview控制器
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  String _wxPayTag;

  _CustomWebViewState(this.url);

  @override
  void initState() {
    super.initState();
    webView = getWeb();
    flutterWebviewPlugin.onScrollYChanged.listen((data) {
      print(data);
    });

    /// 判断双击操作，避免误触退出APP
    doubleClickUtil.registerCallback((value) {
      if (value) {
        flutterWebviewPlugin.dispose();
        flutterWebviewPlugin.close();
        exit(0);
      } else {
        Fluttertoast.showToast(msg: "再点击一次退出APP");
      }
    });

    flutterWebviewPlugin.onStateChanged.listen((state) {
      if (state == WebViewState.finishLoad) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SafeArea(
          top: true,
          child: Container(
            child: TextField(
              onChanged: onEmailChanged,
            ),
          )),
      onWillPop: willpop,
    );
  }

  Function(String) get onEmailChanged {
    BehaviorSubject<String>().value;
  }

  ///
  /// 返回虚拟键的监听
  ///
  Future<bool> willpop() async {
    bool canGoback = await flutterWebviewPlugin.canGoBack();

    if (canGoback) {
      flutterWebviewPlugin.goBack();
    } else {
      doubleClickUtil.click();
    }
    return Future.value(false);
  }

  ///
  /// webview主体
  ///
  WebviewScaffold getWeb() {
    return WebviewScaffold(
      enableAppScheme: true,
      appCacheEnabled: true,
      url: url,
      withJavascript: true,
      javascriptChannels: getJsChannels(context),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(
        color: Colors.white,
        child: const Center(
          child: // 圆形进度条
              CircularProgressIndicator(
            strokeWidth: 4.0,
            backgroundColor: Colors.white,
            // value: 0.2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ),
        ),
      ),
    );
  }

  Set getJsChannels(BuildContext context) {
    return [
      /// 重新登录
      JavascriptChannel(
          name: 'reLogin',
          onMessageReceived: (JavascriptMessage message) {
            print("重新登录");
            NavigatorUtils.getInstance().toLogin(context);
          }),

      /// 调起支付
      JavascriptChannel(
          name: 'wxPay',
          onMessageReceived: (JavascriptMessage message) {
            _wxPayTag = message.message;

            callWechatPay(_wxPayTag);
          }),
    ].toSet();
  }

  ///
  /// webview重新加载
  ///
  void reload() {
    flutterWebviewPlugin.reload();
  }

  ///
  ///  调用微信登录
  ///
  void callWechatPay(String orderInfo) {
    WechatUtil.requestPay(orderInfo, (response) {
      /// 把微信支付结果回调给前端
      flutterWebviewPlugin.evalJavascript("javascript:callPayResult(" + response.errCode.toString() + ",'" + _wxPayTag + "')");
    });
  }
}
