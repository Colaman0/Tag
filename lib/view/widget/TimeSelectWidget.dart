import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

//todo 偶尔会出现滑动过快惯性停下来之后数字没有变大凸显

class TimeSelectView extends StatelessWidget {
  List<int> hours = List();
  List<int> mins = List();
  FixedExtentScrollController _controller =
      FixedExtentScrollController(initialItem: 9);
  PublishSubject<int> hourItemStream = PublishSubject();
  PublishSubject<int> minItemStream = PublishSubject();

  TimeSelectView({Key key}) : super(key: key) {
    for (int i = 1; i < 24; i++) {
      hours.add(i);
    }
    for (int i = 0; i < 60; i++) {
      mins.add(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return View(
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
      ),
    )
        .margin(both: 16)
        .corner(both:8)
        .backgroundColorStr("#3282b8")
        .size(width: View.MATCH, height: 120);
  }

  Widget getHours() => ListWheelScrollView.useDelegate(
        controller: _controller,
        itemExtent: 35,
        physics: FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) => hourItemStream.add(index),
        childDelegate: ListWheelChildListDelegate(
          children: hours.map((value) {
            return StreamBuilder<int>(
              initialData: 9,
              stream: hourItemStream,
              builder: (context, data) => TextView(
                value.toString().padLeft(2, '0'),
                textSize: (value - 1) == data.data ? 35 : 25,
                textColor:
                    (value - 1) == data.data ? Colors.white : Colors.white70,
              ),
            );
          }).toList(),
        ),
      );

  Widget getMins() => ListWheelScrollView.useDelegate(
        itemExtent: 35,
        physics: FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) => minItemStream.add(index),
        childDelegate: ListWheelChildListDelegate(
          children: mins.map((value) {
            return StreamBuilder<int>(
              initialData: 0,
              stream: minItemStream,
              builder: (context, data) => TextView(
                value.toString().padLeft(2, '0'),
                textSize: value == data.data ? 35 : 25,
                textColor: value == data.data ? Colors.white : Colors.white70,
              ),
            );
          }).toList(),
        ),
      );
}