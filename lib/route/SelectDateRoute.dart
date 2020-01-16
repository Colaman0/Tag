import 'package:flutter/material.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/NaigatorUtils.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/CalendarWidget.dart';
import 'package:tag/view/widget/view/TextView.dart';

class SelectDateRoute extends StatelessWidget {
  static final String CREATE_DATE = "create_date";

  @override
  Widget build(BuildContext context) {
    /// 初始日期
    DateTime createTime =
        NavigatorUtils.getPreArguments(context)[CREATE_DATE] as DateTime;
    CalendarWidget calendarWidget = CalendarWidget(time: createTime);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor(Constants.MAIN_COLOR),
        title: Text("选择日期"),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: calendarWidget,
          ),
          Spacer(),
          Container(
              margin: EdgeInsets.all(DP.get(32)),
              child: SizedBox(
                width: double.infinity,
                height: DP.get(70),
                child: RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(DP.get(12)))),
                  icon: Icon(Icons.calendar_today, color: Colors.white30),
                  color: HexColor("#13547a"),
                  label: TextView(
                    "确认",
                    textColor: Colors.white,
                    textSize: 24,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(calendarWidget.getSelectDate());
                  },
                ),
              )),
          SizedBox(
            height: DP.get(32),
          )
        ],
      ),
    );
  }
}
