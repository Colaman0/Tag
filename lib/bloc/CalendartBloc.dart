import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tag/base/bloc.dart';

class CalendarBloc extends BlocBase {
  PublishSubject<DateTime> _selectDateStream = PublishSubject();
  PublishSubject<DateTime> _currentShowMonthTime = PublishSubject();
  DateTime _createDate;
  DateTime _selectDate;

  @override
  void dispose() {
    _selectDateStream.close();
  }

  DateTime getCreateDate() => _createDate;

  /// 设置初始创建日期
  void setCreateDate(DateTime dateTime) {
    _createDate = dateTime;
    _selectDate = _createDate;
  }

  PublishSubject<DateTime> getSelectDateStream() => _selectDateStream;

  PublishSubject<DateTime> getcurrentShowMonthTimeStream() =>
      _currentShowMonthTime;

  void selectDate(DateTime time) {
    _selectDate = DateTime(
        time.year, time.month, time.day, _createDate.hour, _createDate.minute);
    _selectDateStream.add(time);
  }

  DateTime getSelectDate() => _selectDate;
}
