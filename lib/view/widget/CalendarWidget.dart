import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:tag/base/bloc.dart';
import 'package:tag/bloc/CalendartBloc.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/imp/basePage.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

class CalendarWidget extends StatelessWidget {
  CalendarWidget({Key key, this.time, this.selectCallback}) : super(key: key);

  static final CAN_WATCH_YEAR = 3;
  static final startIndex = CAN_WATCH_YEAR * 12;
  PageController _controller = new PageController(initialPage: startIndex);
  final DateTime time;
  final Function selectCallback;
  CalendarBloc _bloc;

  HashMap<int, MonthPage> monthPages = HashMap();

  // 获取选中的日期 年月日
  DateTime getSelectDate() => _bloc?.getSelectDate();

  @override
  Widget build(BuildContext context) {
    _bloc = CalendarBloc(selectCallback);
    _bloc.setCreateDate(time);
    PageView pageView = getPageView();
    return BlocProvider(
        bloc: _bloc,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StreamBuilder<DateTime>(
                stream: _bloc.getcurrentShowMonthTimeStream(),
                initialData: time,
                builder: (context, data) {
                  DateTime currentShowMonth = data.data;
                  return View(
                    child: new Row(
                      children: <Widget>[
                        new Baseline(
                          baseline: 50.0,
                          baselineType: TextBaseline.alphabetic,
                          child: new Text(
                            '${currentShowMonth.year}',
                            style: new TextStyle(
                              fontSize: 35.0,
                              color: HexColor(Constants.COLOR_BLUE),
                              textBaseline: TextBaseline.alphabetic,
                            ),
                          ),
                        ),
                        new Baseline(
                          baseline: 50.0,
                          baselineType: TextBaseline.alphabetic,
                          child: new Text(
                            ' 年 ',
                            style: new TextStyle(
                              fontSize: 20.0,
                              textBaseline: TextBaseline.alphabetic,
                            ),
                          ),
                        ),
                        new Baseline(
                          baseline: 50.0,
                          baselineType: TextBaseline.alphabetic,
                          child: new Text(
                            '${currentShowMonth.month}',
                            style: new TextStyle(
                              fontSize: 35.0,
                              color: HexColor(Constants.COLOR_BLUE),
                              textBaseline: TextBaseline.alphabetic,
                            ),
                          ),
                        ),
                        new Baseline(
                          baseline: 50.0,
                          baselineType: TextBaseline.alphabetic,
                          child: new Text(
                            ' 月',
                            style: new TextStyle(
                              fontSize: 20.0,
                              textBaseline: TextBaseline.alphabetic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).margin(left: 24);
                }),
            SizedBox(
              width: double.infinity,
              height: DP.get(32),
            ),
            Divider(color: Colors.grey),
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                alignment: Alignment.topCenter,
                child: pageView,
              ),
            ),
          ],
        ));
  }

  PageView getPageView() => PageView.builder(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: CAN_WATCH_YEAR * 12 * 2,
      onPageChanged: (pageIndex) {
        _bloc
            .getcurrentShowMonthTimeStream()
            .add(monthPages[pageIndex].getCurrentMonthTime());
      },
      itemBuilder: (context, index) {
        MonthPage page = MonthPage(
          index: index,
          dateTime: time,
        );
        // 保存每个月的MonthPage控件到map里
        monthPages.putIfAbsent(index, () => page);
        return page;
      });
}

class MonthPage extends StatefulWidget {
  final index;
  final DateTime dateTime;
  _MonthPageState _state;

  MonthPage({Key key, this.index, this.dateTime}) : super(key: key);

  @override
  _MonthPageState createState() {
    _state = _MonthPageState(index, dateTime);
    return _state;
  }

  getCurrentMonthTime() => _state.currentMonth;
}

class _MonthPageState extends State<MonthPage>
    with AutomaticKeepAliveClientMixin {
  final index;
  final DateTime nowDateTime;

  DateTime currentMonth;

  _MonthPageState(
    this.index,
    this.nowDateTime,
  ) {
    int year = nowDateTime.year;
    int different = CalendarWidget.startIndex - index;

    // 算出差了多少年
    int yearDifferent = different.abs() ~/ 12;
    // 算出月份差距
    int monthDifferent = different.abs() % 12;

    // 根据年月的差值算出当前page是代表哪一年哪个月份
    currentMonth = DateTime(
        different < 0 ? year + yearDifferent : year - yearDifferent,
        different < 0
            ? nowDateTime.month + monthDifferent
            : nowDateTime.month - monthDifferent);
  }

  @override
  Widget build(BuildContext context) {
    int skipCount = DateUtil.getIndexOfFirstDayInMonth(currentMonth);

    return StreamBuilder<DateTime>(builder: (context, data) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: getWeekTitles()),
          Divider(color: Colors.grey),
          MediaQuery.removePadding(
              removeBottom: true,
              removeTop: true,
              context: context,
              child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7),
                  itemCount: skipCount -
                      1 +
                      DateUtil.getMonthDaysCount(
                          currentMonth.year, currentMonth.month),
                  itemBuilder: (context, index) {
                    if (index + 1 < skipCount) {
                      return TextView("");
                    } else {
                      int day = index - (skipCount - 2);
                      // 算出当前item代表的日期
                      DateTime itemTime =
                          DateTime(currentMonth.year, currentMonth.month, day);
                      return DateItem(itemTime);
                    }
                  }))
        ],
      );
    });
  }

  List<Widget> getDateItem() {
    List<Widget> widgets = List();
    for (int i = 0; i < 7; i++) {
      DateUtil.getIndexOfFirstDayInMonth(currentMonth);
    }
    return widgets;
  }

  List<Widget> getWeekTitles() => [
        Expanded(
            child: TextView(
          "一",
          textSize: 24,
        )),
        Expanded(
            child: TextView(
          "二",
          textSize: 24,
        )),
        Expanded(
            child: TextView(
          "三",
          textSize: 24,
        )),
        Expanded(
            child: TextView(
          "四",
          textSize: 24,
        )),
        Expanded(
            child: TextView(
          "五",
          textSize: 24,
        )),
        Expanded(
            child: TextView(
          "六",
          textSize: 24,
        )),
        Expanded(
            child: TextView(
          "日",
          textSize: 24,
        )),
      ];

  @override
  bool get wantKeepAlive => true;
}

class DateItem extends StatefulWidget {
  final DateTime itemTime;

  DateItem(this.itemTime);

  @override
  _DateItemState createState() => _DateItemState(itemTime);
}

class _DateItemState extends State<DateItem> {
  final DateTime itemTime;
  final String _weekendColors = Constants.COLOR_BLUE;
  final Color itemSelectTextColor = Colors.white;
  final Color itemNormalTextColor = HexColor(Constants.MAIN_COLOR);

  CalendarBloc _bloc;
  Widget _child;

  _DateItemState(this.itemTime);

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_child == null) {
      _child = AspectRatio(
          aspectRatio: 1,
          child: Container(
            child: View(
              child: TextView(
                "${itemTime.day}",
                textColor: DateUtil.isWeekend(itemTime)
                    ? HexColor(_weekendColors)
                    : HexColor(Constants.MAIN_COLOR),
                textSize: 20,
              ).circle(),
            ).circle().click(() {
              _bloc.selectDate(itemTime);
            }),
          ));
    }
    return StreamBuilder<DateTime>(
      stream: _bloc.getSelectDateStream(),
      // 默认选中的日期是创建的日期
      initialData: _bloc.getCreateDate(),
      builder: (context, data) {
        if (DateUtil.isSameDay(data.data, itemTime)) {
          return AspectRatio(
              aspectRatio: 1,
              child: Container(
                child: View(
                        child: TextView(
                  "${itemTime.day}",
                  textColor: Colors.white,
                  textSize: 26,
                ))
                    .circle()
                    .backgroundColorStr(Constants.MAIN_COLOR)
                    .click(() {}),
              ));
        } else {
          return _child;
        }
      },
    );
  }
}

/**
 * 工具类
 */
class DateUtil {
  /**
   * 判断一个日期是否是周末，即周六日
   */
  static bool isWeekend(DateTime dateTime) {
    return dateTime.weekday == DateTime.saturday ||
        dateTime.weekday == DateTime.sunday;
  }

  /**
   * 获取某年的天数
   */
  static int getYearDaysCount(int year) {
    if (isLeapYear(year)) {
      return 366;
    }
    return 365;
  }

  /**
   * 获取某月的天数
   *
   * @param year  年
   * @param month 月
   * @return 某月的天数
   */
  static int getMonthDaysCount(int year, int month) {
    int count = 0;
    //判断大月份
    if (month == 1 ||
        month == 3 ||
        month == 5 ||
        month == 7 ||
        month == 8 ||
        month == 10 ||
        month == 12) {
      count = 31;
    }

    //判断小月
    if (month == 4 || month == 6 || month == 9 || month == 11) {
      count = 30;
    }

    //判断平年与闰年
    if (month == 2) {
      if (isLeapYear(year)) {
        count = 29;
      } else {
        count = 28;
      }
    }
    return count;
  }

  /**
   * 是否是今天
   */
  static bool isCurrentDay(int year, int month, int day) {
    DateTime now = DateTime.now();
    return now.year == year && now.month == month && now.day == day;
  }

  static bool isSameDay(DateTime dateTime1, DateTime dateTime2) {
    return dateTime1.year == dateTime2.year &&
        dateTime1.month == dateTime2.month &&
        dateTime1.day == dateTime2.day;
  }

  /**
   * 是否是闰年
   */
  static bool isLeapYear(int year) {
    return ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
  }

  /**
   * 本月的第几周
   */
  static int getIndexWeekInMonth(DateTime dateTime) {
    DateTime firstdayInMonth = new DateTime(dateTime.year, dateTime.month, 1);
    Duration duration = dateTime.difference(firstdayInMonth);
    return (duration.inDays / 7).toInt() + 1;
  }

  /**
   * 本周的第几天
   */
  static int getIndexDayInWeek(DateTime dateTime) {
    DateTime firstdayInMonth = new DateTime(
      dateTime.year,
      dateTime.month,
    );
    Duration duration = dateTime.difference(firstdayInMonth);
    return (duration.inDays / 7).toInt() + 1;
  }

  /**
   * 本月第一天，是那一周的第几天,从1开始
   * @return 获取日期所在月视图对应的起始偏移量 the start diff with MonthView
   */
  static int getIndexOfFirstDayInMonth(DateTime dateTime) {
    DateTime firstDayOfMonth = new DateTime(dateTime.year, dateTime.month, 1);

    int week = firstDayOfMonth.weekday;

    return week;
  }

  static List<DateModel> initCalendarForMonthView(
      int year, int month, DateTime currentDate, int weekStart,
      {DateModel minSelectDate,
      DateModel maxSelectDate,
      Map<DateModel, Object> extraDataMap}) {
    print('initCalendarForMonthView start');
    weekStart = DateTime.monday;
    //获取月视图其实偏移量
    int mPreDiff = getIndexOfFirstDayInMonth(new DateTime(year, month));
    //获取该月的天数
    int monthDayCount = getMonthDaysCount(year, month);

    List<DateModel> result = new List();

    int size = 42;

    DateTime firstDayOfMonth = new DateTime(year, month, 1);
    DateTime lastDayOfMonth = new DateTime(year, month, monthDayCount);

    for (int i = 0; i < size; i++) {
      DateTime temp;
      DateModel dateModel;
      if (i < mPreDiff - 1) {
        //这个上一月的几天
        temp = firstDayOfMonth.subtract(Duration(days: mPreDiff - i - 1));

        dateModel = DateModel.fromDateTime(temp);
        dateModel.isCurrentMonth = false;
      } else if (i >= monthDayCount + (mPreDiff - 1)) {
        //这是下一月的几天
        temp = lastDayOfMonth
            .add(Duration(days: i - mPreDiff - monthDayCount + 2));
        dateModel = DateModel.fromDateTime(temp);
        dateModel.isCurrentMonth = false;
      } else {
        //这个月的
        temp = new DateTime(year, month, i - mPreDiff + 2);
        dateModel = DateModel.fromDateTime(temp);
        dateModel.isCurrentMonth = true;
      }

      //判断是否在范围内
      if (dateModel.getDateTime().isAfter(minSelectDate.getDateTime()) &&
          dateModel.getDateTime().isBefore(maxSelectDate.getDateTime())) {
        dateModel.isInRange = true;
      } else {
        dateModel.isInRange = false;
      }
      //将自定义额外的数据，存储到相应的model中
      if (extraDataMap?.isNotEmpty == true) {
        if (extraDataMap.containsKey(dateModel)) {
          dateModel.extraData = extraDataMap[dateModel];
        } else {
          dateModel.extraData = null;
        }
      } else {
        dateModel.extraData = null;
      }

      result.add(dateModel);
    }

    print('initCalendarForMonthView end');

    return result;
  }

  /**
   * 月的行数
   */
  static int getMonthViewLineCount(int year, int month) {
    DateTime firstDayOfMonth = new DateTime(year, month, 1);
    int monthDayCount = getMonthDaysCount(year, month);
//    DateTime lastDayOfMonth = new DateTime(year, month, monthDayCount);

    int preIndex = firstDayOfMonth.weekday - 1;
//    int lastIndex = lastDayOfMonth.weekday;

    return ((preIndex + monthDayCount) / 7).toInt() + 1;
  }

  /**
   * 获取本周的7个item
   */
  static List<DateModel> initCalendarForWeekView(
      int year, int month, DateTime currentDate, int weekStart,
      {DateModel minSelectDate,
      DateModel maxSelectDate,
      Map<DateModel, Object> extraDataMap}) {
    List<DateModel> items = List();

    int weekDay = currentDate.weekday;

    //计算本周的第一天
    DateTime firstDayOfWeek = currentDate.add(Duration(days: -weekDay));

    for (int i = 1; i <= 7; i++) {
      DateModel dateModel =
          DateModel.fromDateTime(firstDayOfWeek.add(Duration(days: i)));

      //判断是否在范围内
      if (dateModel.getDateTime().isAfter(minSelectDate.getDateTime()) &&
          dateModel.getDateTime().isBefore(maxSelectDate.getDateTime())) {
        dateModel.isInRange = true;
      } else {
        dateModel.isInRange = false;
      }
      if (month == dateModel.month) {
        dateModel.isCurrentMonth = true;
      } else {
        dateModel.isCurrentMonth = false;
      }

      //将自定义额外的数据，存储到相应的model中
      if (extraDataMap?.isNotEmpty == true) {
        if (extraDataMap.containsKey(dateModel)) {
          dateModel.extraData = extraDataMap[dateModel];
        }
      }

      items.add(dateModel);
    }
    return items;
  }
}
