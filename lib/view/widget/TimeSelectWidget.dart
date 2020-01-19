import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

//todo 偶尔会出现滑动过快惯性停下来之后数字没有变大凸显

class TimeSelectView extends StatelessWidget {
  List<int> hours = List();
  List<int> mins = List();
  final DateTime dateTime;

  FixedExtentScrollController _hourController;

  FixedExtentScrollController _minController;

  PublishSubject<int> hourItemStream = PublishSubject();
  PublishSubject<int> minItemStream = PublishSubject();
  PublishSubject<DateTime> timeStream;

  int selectHour, selectMin;

  TimeSelectView({Key key, this.dateTime, this.timeStream}) : super(key: key) {
    for (int i = 1; i < 24; i++) {
      hours.add(i);
    }
    for (int i = 0; i < 60; i++) {
      mins.add(i);
    }

    _hourController =
        FixedExtentScrollController(initialItem: dateTime.hour - 1);
    _minController = FixedExtentScrollController(initialItem: dateTime.minute);
  }

  int getSelectHour() => ++selectHour;

  int getSelectMin() => selectMin;

  @override
  Widget build(BuildContext context) {
    return View(
      child: Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              TextView(
                "取消",
                textSize: 22,
                textColor: Colors.white,
              ).padding(top: 12, bottom: 12, left: 24, right: 24).click(() {
                Navigator.of(context).pop();
              }),
              Spacer(),
              TextView(
                "确定",
                textSize: 22,
                textColor: Colors.white,
              ).padding(top: 12, bottom: 12, left: 24, right: 24).click(() {
                timeStream.add(DateTime(dateTime.year, dateTime.month,
                    dateTime.day, selectHour + 1, selectMin));
                Navigator.of(context).pop();
              }),
            ]),
          ),
          Container(
            color: Colors.white,
            height: 0.1,
            margin: EdgeInsets.only(bottom: DP.get(8)),
          ),
          Expanded(
              child: Row(
            children: <Widget>[
              Expanded(
                child: getHours(),
              ),
              TextView(
                ":",
                textSize: 50,
                textColor: Colors.white,
              ),
              Expanded(
                child: getMins(),
              )
            ],
          ))
        ],
      ),
    )
        .padding(bottom: 32)
        .backgroundColorStr("#13547a")
        .size(width: View.MATCH, height: 220);
  }

  Widget getHours() => ListWheelScrollView.useDelegate(
        controller: _hourController,
        itemExtent: 35,
        physics: FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) => hourItemStream.add(index),
        childDelegate: ListWheelChildListDelegate(
          children: hours.map((value) {
            return StreamBuilder<int>(
                initialData: dateTime.hour - 1,
                stream: hourItemStream,
                builder: (context, data) {
                  selectHour = data.data;
                  return TextView(
                    value.toString().padLeft(2, '0'),
                    textSize: (value - 1) == data.data ? 35 : 25,
                    textColor: (value - 1) == data.data
                        ? Colors.white
                        : Colors.white70,
                  );
                });
          }).toList(),
        ),
      );

  Widget getMins() => ListWheelScrollView.useDelegate(
        itemExtent: 35,
        physics: FixedExtentScrollPhysics(),
        controller: _minController,
        onSelectedItemChanged: (index) => minItemStream.add(index),
        childDelegate: ListWheelChildListDelegate(
          children: mins.map((value) {
            return StreamBuilder<int>(
                initialData: dateTime.minute,
                stream: minItemStream,
                builder: (context, data) {
                  selectMin = data.data;
                  return TextView(
                    value.toString().padLeft(2, '0'),
                    textSize: value == data.data ? 35 : 25,
                    textColor:
                        value == data.data ? Colors.white : Colors.white70,
                  );
                });
          }).toList(),
        ),
      );
}
