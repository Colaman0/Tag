import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/NaigatorUtils.dart';
import 'package:tag/util/util.dart';

void main() {
  debugPaintSizeEnabled = !true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: NavigatorUtils.routeMap,
    );
  }
}
