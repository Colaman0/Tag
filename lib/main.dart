import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:tag/util/NaigatorUtils.dart';
import 'package:tag/util/UserNavigatorObserver.dart';

void main() {
  debugPaintSizeEnabled = !true;
  runApp(MyApp());

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers:[UserNavigatorObserver()] ,
      initialRoute: '/',
      routes: NavigatorUtils.routeMap,
    );
  }

  PageTransitionsBuilder createTransition() {
    return FadeTransitionsBuilder();
  }
}

class FadeTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
