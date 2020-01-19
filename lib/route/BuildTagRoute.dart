import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tag/base/bloc.dart';
import 'package:tag/bloc/BuildTagBloc.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/tag/SearchCategoryRoute.dart';
import 'package:tag/view/widget/CalendarWidget.dart';
import 'package:tag/view/widget/CategroyItemWidget.dart';
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
                    HexColor("#537895"),
                    HexColor("#868f96")
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
                      autofocus: false,
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
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                getDateItem(),
                                getTimeItem(),
                                getCategoryItem(),
                                SizedBox(
                                  height: DP.get(32),
                                )
                              ],
                            ),
                          ),
                        ),
                        getConfirmButton()
                      ],
                    ))
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
      showBottomSheet(
          context: _context,
          backgroundColor: Colors.black38,
          builder: (context) {
            DateTime time = _tagBloc.getSelectDate();
            return Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    View(
                      child: CalendarWidget(
                          time: time ?? _createTime,
                          selectCallback: (date) {
                            time = date;
                          }),
                    )
                        .backgroundColor(Colors.white)
                        .corner(rightTop: 20, leftTop: 20),
                    SizedBox(
                      width: double.infinity,
                      height: DP.get(70),
                      child: RaisedButton(
                        child: TextView(
                          "确定",
                          textColor: Colors.white,
                          textSize: 24,
                        ),
                        color: HexColor("#13547a"),
                        onPressed: () {
                          if (!time.isAtSameMomentAs(
                              _tagBloc.getSelectDate() ?? _createTime)) {
                            _tagBloc.selectDate(time);
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ));
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
      showBottomSheet(
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
    return StreamBuilder<List<String>>(
        initialData: ["1123", "32131", "23151"],
        stream: _tagBloc.getTagsStream(),
        builder: (context, data) {
          ///  把标签list转换成对应的chip控件显示
          List<Widget> children = data.data
              .map((tagName) => CategoryItemWidget(
                    clickAble: true,
                    removeAble: true,
                    name: tagName,
                    removeCallback: (name) => _tagBloc.removeCategoryItem(name),
                  ))
              .toList();
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                View(
                  child: Row(children: <Widget>[
                    TextView(
                      "标签 (最多三个)",
                      textSize: 24,
                      textColor: Colors.grey,
                    ).aligment(Alignment.centerLeft),
                    Spacer(),
                    Icon(Icons.add)
                  ]),
                ).padding(top: 12, bottom: 12).click(() {
                  int maxSize = 3 - children.length;
                  if (maxSize == 0) {
                    return;
                  }
                  showSearch(
                      context: _context, delegate: CategorySearch(maxSize));
                }),
                Wrap(
                  runAlignment: WrapAlignment.start,
                  children: children,
                  spacing: DP.get(16),
                ),
              ]);
        });
  }
}
