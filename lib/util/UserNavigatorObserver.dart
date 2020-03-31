import 'package:flutter/cupertino.dart';

class UserNavigatorObserver extends NavigatorObserver {
  static List<Route<dynamic>> history = <Route<dynamic>>[];

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    history.remove(route);

    ///调用Navigator.of(context).pop() 出栈时回调
  }

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    history.add(route);

    ///调用Navigator.of(context).push(Route()) 进栈时回调
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    super.didRemove(route, previousRoute);
    history.remove(route);

    ///调用Navigator.of(context).removeRoute(Route()) 移除某个路由回调
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    history.remove(oldRoute);
    history.add(newRoute);

    ///调用Navigator.of(context).replace( oldRoute:Route("old"),newRoute:Route("new")) 替换路由时回调
  }

  @override
  void didStartUserGesture(Route route, Route previousRoute) {
    super.didStartUserGesture(route, previousRoute);

    ///iOS侧边手势滑动触发回调 手势开始时回调
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();

    ///iOS侧边手势滑动触发停止时回调 不管页面是否退出了都会调用
  }
}
