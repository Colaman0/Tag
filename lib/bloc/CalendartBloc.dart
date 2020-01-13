import 'package:rxdart/rxdart.dart';
import 'package:tag/base/bloc.dart';

class CalendarBloc extends BlocBase {
  PublishSubject<DateTime> _selectDateStream = PublishSubject();
  PublishSubject<DateTime> _currentShowMonthTime = PublishSubject();
  DateTime _createData;
  DateTime _selectDate;

  @override
  void dispose() {
    _selectDateStream.close();
  }

  DateTime getCreateDate() => _createData;

  /// 设置初始创建日期
  void setCreateDate(DateTime dateTime) {
    _createData = dateTime;
    _selectDate = _createData;
  }

  PublishSubject<DateTime> getSelectDateStream() => _selectDateStream;

  PublishSubject<DateTime> getcurrentShowMonthTimeStream() =>
      _currentShowMonthTime;

  void selectDate(DateTime time) {
    _selectDate = time;
    _selectDateStream.add(time);
  }

  DateTime getSelectDate() => _selectDate;
}
