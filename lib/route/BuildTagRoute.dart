import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tag/base/bloc.dart';
import 'package:tag/bloc/BuildTagBloc.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/imp/basePage.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/flag/SelectFlagBg.dart';
import 'package:tag/view/widget/CalendarWidget.dart';
import 'package:tag/view/widget/StatusBar.dart';
import 'package:tag/view/widget/TimeSelectWidget.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

class BuildTagRoute extends StatelessWidget {
  static final TAG = "Tag";
  static final FLAG = "Flag";

  // build类型
  final buildType;

  BuildTagBloc _tagBloc = BuildTagBloc();

  PublishSubject pageStream = PublishSubject<int>();

  PageController _pageController = PageController();
  List<Widget> pages = List();

  Color mainColor = HexColor(Constants.COLOR_BLUE);

  BuildTagRoute({this.buildType});

  @override
  Widget build(BuildContext context) {
    pages.clear();
    pages.addAll(getPages());

    return StatusBar(
        color: HexColor(Constants.COLOR_BLUE),
        child: BlocProvider(
          bloc: _tagBloc,
          child: Container(
            color: mainColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    View(
                      child: Icon(Icons.arrow_back,
                          size: DP.get(48), color: Colors.white),
                    ).size(width: 64, height: 64).click(() {
                      Navigator.of(context).pop();
                    }),
                    Hero(
                      tag: buildType,
                      child: TextView(buildType,
                              textColor: Colors.white, textSize: 35)
                          .margin(left: 16),
                    )
                  ],
                ),
                StreamBuilder(
                  initialData: "选择时间",
                  stream: _tagBloc.getFuntionStrStream(),
                  builder: (context, data) => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: TextView(
                      data.data,
                      textSize: 36,
                      textColor: Colors.white,
                      key: ValueKey<String>(data.data),
                    ).aligment(Alignment.centerLeft).margin(left: 16, top: 16),
                  ),
                ),
                Expanded(
                  child: View(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: PageView(
                            onPageChanged: (page) => pageStream.add(page),
                            controller: _pageController,
                            physics: NeverScrollableScrollPhysics(),
                            children: pages,
                          ),
                        ),
                        bottomActionWidget()
                      ],
                    ),
                  )
                      .size(width: View.MATCH, height: View.MATCH)
                      .corner(leftTop: 24, rightTop: 24)
                      .margin(top: 48)
                      .backgroundColor(Colors.white),
                )
              ],
            ),
          ),
        ));
  }

  List<Widget> getPages() {
    List<Widget> pages = List();
    pages.add(DateTimeWidget(DateTime.now(), _tagBloc));
    if (buildType == TAG) {
    } else {
      pages.add(SelectFlagBg());
    }
    /// 把bloc注入到每一个Page当中
    pages.forEach((page) {
      if (page is BasePage) {
        (page as BasePage).injectBloc(_tagBloc);
      }
    });

    return pages;
  }

  Widget getTitles() {
    return Row(
      children: <Widget>[],
    );
  }

  // 底部action 用于切换上一步下一步
  Widget bottomActionWidget() {
    return StreamBuilder(
      initialData: 0,
      stream: pageStream,
      builder: (context, data) {
        int page = data.data;
        return Container(
          margin: EdgeInsets.only(top: DP.get(32), bottom: DP.get(32)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              OutlineButton(
                textColor: Colors.black,
                disabledTextColor: Colors.grey,
                child: Text("上一步"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                onPressed: page == 0
                    ? null
                    : () {
                        _pageController.animateToPage(--page,
                            duration: Duration(milliseconds: 100),
                            curve: Curves.bounceIn);
                      },
              ),
              MaterialButton(
                animationDuration: Duration(microseconds: 300),
                color: HexColor(Constants.COLOR_BLUE),
                textColor: Colors.white,
                disabledTextColor: Colors.white,
                disabledColor: HexColor(Constants.COLOR_3),
                child: Text("下一步"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                onPressed: () {
                  if (page >= pages.length - 1) {
                    // 提交
                    return;
                  }
                  BasePage basePage = (pages[page] as BasePage);
                  if (basePage.dataVaild()) {
                    /// 切换到下一页的时候保存当页的数据
                    basePage.saveData();
                    _pageController.animateToPage(++page,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.linear);
                  } else {
                    Fluttertoast.showToast(msg: basePage.dataTips());
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }
}

// 时间选择器widget
class DateTimeWidget extends StatefulWidget with BasePage {
  final DateTime dateTime;
  final BuildTagBloc _tagBloc;
  _DateTimeWidgetState _state;

  DateTimeWidget(this.dateTime, this._tagBloc);

  @override
  _DateTimeWidgetState createState() {
    _state = _DateTimeWidgetState(dateTime, _tagBloc);
    return _state;
  }

  @override
  String dataTips() {
    // TODO: implement dataTips
    return "请选择日期";
  }

  @override
  bool dataVaild() {
    return true;
  }

  @override
  void saveData() => _state.saveData();
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  final DateTime dateTime;
  final BuildTagBloc _tagBloc;

  _DateTimeWidgetState(this.dateTime, this._tagBloc);

  CalendarWidget _calendarWidget;

  TimeSelectView _timeSelectView;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calendarWidget = CalendarWidget(time: dateTime);
    _timeSelectView = TimeSelectView(dateTime: dateTime);
  }

  /// 保存用户最后选中的日期
  void saveData() {
    var selectDate = _calendarWidget.getSelectDate();
    DateTime finalSelectDate = DateTime(
        selectDate.year,
        selectDate.month,
        selectDate.day,
        _timeSelectView.getSelectHour(),
        _timeSelectView.getSelectMin());
    _tagBloc.selectDate(finalSelectDate);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: View(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[_calendarWidget, _timeSelectView],
        ),
      ),
    );
  }
}
