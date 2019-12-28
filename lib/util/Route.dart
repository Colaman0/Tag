import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class RouterManager {
  static RouterManager _instance;

  static Router _router = Router();

  RouterManager._();

  static RouterManager getInstance() {
    if (_instance == null) {
      _instance = RouterManager._();
    }
    return _instance;
  }

  ///
  /// 初始化router
  ///
  static void configureRoutes(Router router) {
    _router = router;
    router.notFoundHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!! $params");
      return Text("");
    });
  }

  static void navigateTo(BuildContext context, String routerName, {Map<String, dynamic> params, TransitionType transitionType}) {

  }
}
