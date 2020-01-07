import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/widget/calendar_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

class CalendarWidget extends StatelessWidget {
  CalendarWidget({Key key}) : super(key: key);
  static final startIndex = 1 * 12;
  PageController _controller = new PageController(initialPage: 12);
  int _lastPageIndex;
  final DateTime nowTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Padding(
        padding: EdgeInsets.all(DP.get(8)),
        child: PageView.builder(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: 2 * 12,
            onPageChanged: (pageIndex) {
              _lastPageIndex = pageIndex;
            },
            itemBuilder: (context, index) =>
                MonthPage(index: index, dateTime: nowTime)),
      ),
    );
  }
}

class MonthPage extends StatefulWidget {
  final index;
  final dateTime;

  const MonthPage({Key key, this.index, this.dateTime}) : super(key: key);

  @override
  _MonthPageState createState() => _MonthPageState(index, dateTime);
}

class _MonthPageState extends State<MonthPage>
    with AutomaticKeepAliveClientMixin {
  final index;
  final DateTime nowDateTime;

  DateTime currentMonth;


  _MonthPageState(this.nowDateTime, this.index) {
    int year = nowDateTime.year;
    int tagYear = CalendarWidget.startIndex - index;

    while(tagYear >=12) {
      tagYear-=12;
      year--;
    }
    if(index - CalendarWidget.startIndex >0 ) {
      currentMonth = nowDateTime.add(Duration(days: DateUtil.getMonthDaysCount(nowDateTime.year, nowDateTime.month)));
    }else{
      currentMonth = nowDateTime.subtract(Duration(days: DateUtil.getMonthDaysCount(nowDateTime.year, nowDateTime.month)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextView(index.toString()),
    );
  }

  @override
  bool get wantKeepAlive => true;
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
        }else{
          dateModel.extraData=null;
        }
      }else{
        dateModel.extraData=null;
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
