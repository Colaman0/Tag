import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/tag/HomeTagListWidget.dart';
import 'package:tag/view/widget/view/HomeCalendarWidget.dart';

class HomeTagContentWidget extends StatefulWidget {
  @override
  _HomeTagContentWidgetState createState() => _HomeTagContentWidgetState();
}

class _HomeTagContentWidgetState extends State<HomeTagContentWidget> {
  bool _calendarMode = true;

  HomeCalendarWidget _homeCalendarWidget;
  HomeTagListWidget _homeTagListWidget;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Positioned(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: _calendarMode ? getCalendarWidget() : getListWidget(),
        ),
      ),
      Positioned(
        right: DP.toDouble(32),
        bottom: DP.toDouble(48),
        child: FloatingActionButton(
          heroTag: Object(),
          child: Icon(_calendarMode ? Icons.calendar_today : Icons.list),
          onPressed: () {
            setState(() {
              _calendarMode = !_calendarMode;
            });
          },
          backgroundColor: HexColor(Constants.COLOR_BLUE),
        )
      )
    ]);

  }

  Widget getCalendarWidget() {
    if (_homeCalendarWidget == null) {
      _homeCalendarWidget = HomeCalendarWidget();
    }
    return _homeCalendarWidget;
  }

  Widget getListWidget() {
    if (_homeTagListWidget == null) {
      _homeTagListWidget = HomeTagListWidget();
    }
    return _homeTagListWidget;
  }
}
