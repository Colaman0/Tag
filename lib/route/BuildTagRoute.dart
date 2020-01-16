import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tag/base/bloc.dart';
import 'package:tag/bloc/BuildTagBloc.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/NaigatorUtils.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/TimeSelectWidget.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

class BuildTagRoute extends StatelessWidget {
  static final TAG = "Tag";
  static final FLAG = "Flag";

  // build类型
  final buildType;

  BuildTagBloc _tagBloc = BuildTagBloc();
  BuildContext _context;

  PublishSubject pageStream = PublishSubject<int>();

  PageController _pageController = PageController();
  List<Widget> pages = List();

  Color mainColor = HexColor("#FBDDCA");

  BuildTagRoute({this.buildType});

  DateTime _createTime;

  @override
  Widget build(BuildContext context) {
    _createTime = DateTime.now();
    return BlocProvider(
        bloc: _tagBloc,
        child: Scaffold(body: Builder(
          builder: (BuildContext context) {
            _context = context;

            return Container(
              padding: EdgeInsets.only(top: ScreenUtil.statusBarHeight),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                    HexColor("#13547a"),
                    HexColor("#80d0c7")
                  ])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  View(
                    child: Icon(Icons.arrow_back,
                        size: DP.get(48), color: Colors.white),
                  ).size(width: 64, height: 64).click(() {
                    Navigator.of(context).pop();
                  }),
                  TextView(
                    "Create",
                    textSize: 40,
                    textColor: Colors.white,
                  ).aligment(Alignment.centerLeft).margin(left: 16, top: 12),
                  TextView(
                    "New Flag",
                    textSize: 40,
                    textColor: Colors.white,
                  ).aligment(Alignment.centerLeft).margin(left: 16, top: 4),
                  View(
                      child: Material(
                    color: Colors.transparent,
                    child: TextField(
                      style:
                          TextStyle(color: Colors.white, fontSize: SP.get(28)),
                      cursorColor: Colors.white70,
                      maxLines: 1,
                      maxLength: 10,
                      autofocus: true,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: HexColor(Constants.MAIN_COLOR))),
                          hintStyle: TextStyle(color: Colors.white),
                          hintText: "输入标题",
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: HexColor(Constants.MAIN_COLOR)))),
                    ),
                  )).margin(left: 16, right: 16, top: 16),
                  SizedBox(
                    height: DP.get(24),
                  ),
                  Expanded(
                    child: View(
                      child: Column(
                        children: <Widget>[
                          getDateItem(),
                          getTimeItem(),
                          getBackgroundItem(),
                          getCategoryItem(),
                          Spacer(),
                          getConfirmButton()
                        ],
                      ),
                    )
                        .padding(both: 32)
                        .size(width: View.MATCH, height: View.MATCH)
                        .corner(leftTop: 30, rightTop: 30)
                        .backgroundColor(Colors.white),
                  )
                ],
              ),
            );
          },
        )));
  }

  Widget getDateItem() {
    DateTime time;
    return View(
      child: Column(
        children: <Widget>[
          TextView(
            "日期",
            textSize: 24,
            textColor: Colors.grey,
          ).aligment(Alignment.centerLeft),
          StreamBuilder<DateTime>(
              initialData: _createTime,
              stream: _tagBloc.getSelectDateStream(),
              builder: (context, data) {
                time = data.data;
                String dateStr = "${time.year} 年 ${time.month} 月 ${time.day} 日";
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: TextView(
                        dateStr,
                        textSize: 28,
                      ).aligment(Alignment.centerLeft).margin(top: 12),
                    ),
                    Icon(
                      Icons.calendar_today,
                      size: DP.get(24),
                      color: HexColor("#313B79"),
                    )
                  ],
                );
              }),
          Divider(
            color: HexColor("#313B79"),
          )
        ],
      ),
    ).click(() {
      NavigatorUtils.getInstance().toSelectDate(_context, time).then((date) {
        if (date != null) {
          _tagBloc.getSelectDateStream().add(date);
        }
      });
    });
  }

  Widget getTimeItem() {
    DateTime time;
    return View(
      child: Column(
        children: <Widget>[
          TextView(
            "时间",
            textSize: 24,
            textColor: Colors.grey,
          ).aligment(Alignment.centerLeft),
          StreamBuilder<DateTime>(
              initialData: _createTime,
              stream: _tagBloc.getSelectDateStream(),
              builder: (context, data) {
                time = data.data;
                String dateStr = "${time.hour} 时 ${time.minute} 分 ";
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: TextView(
                        dateStr,
                        textSize: 28,
                      ).aligment(Alignment.centerLeft).margin(top: 12),
                    ),
                    Icon(
                      Icons.timelapse,
                      size: DP.get(24),
                      color: HexColor("#313B79"),
                    )
                  ],
                );
              }),
          Divider(
            color: HexColor("#313B79"),
          )
        ],
      ),
    ).margin(top: 32, bottom: 32).click(() {
      PersistentBottomSheetController controller = showBottomSheet(
          context: _context,
          backgroundColor: Colors.black38,
          builder: (context) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.bottomCenter,
              child: TimeSelectView(
                  dateTime: time, timeStream: _tagBloc.getSelectDateStream()),
            );
          });
    });
  }

  Widget getBackgroundItem() {
    return Column(children: <Widget>[
      TextView(
        "背景图",
        textSize: 24,
        textColor: Colors.grey,
      ).aligment(Alignment.centerLeft),
      View(
        child: Icon(Icons.add),
      )
          .corner(both: 10)
          .backgroundColor(HexColor("#EBEEF4"))
          .size(width: View.MATCH, height: 96)
          .margin(top: 16)
          .click(() {}),
    ]);
  }

  Widget getConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: DP.get(70),
      child: RaisedButton.icon(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(DP.get(12)))),
        icon: Icon(Icons.add_circle, color: Colors.white30),
        color: HexColor("#13547a"),
        label: TextView(
          "创建",
          textColor: Colors.white,
          textSize: 24,
        ),
        onPressed: () {},
      ),
    );
  }

  Widget getCategoryItem() {
    return Column(children: <Widget>[
      TextView(
        "标签 (最多三个)",
        textSize: 24,
        textColor: Colors.grey,
      ).aligment(Alignment.centerLeft),
      View(
        child: Icon(Icons.add),
      )
          .corner(both: 10)
          .backgroundColor(HexColor("#EBEEF4"))
          .size(width: View.MATCH, height: 96)
          .margin(top: 16)
          .click(() {}),
    ]);
  }
}
