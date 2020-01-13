import 'package:rxdart/rxdart.dart';
import 'package:tag/base/bloc.dart';

class CalendarBloc extends BlocBase {
  PublishSubject<DateTime> _selectDate = PublishSubject();
  PublishSubject<DateTime> _currentShowMonthTime = PublishSubject();
  DateTime _createData;

  @override
  void dispose() {
    _selectDate.close();
  }

  DateTime getCreateDate() => _createData;

  void setCreateDate(DateTime dateTime) => _createData = dateTime;

  PublishSubject<DateTime> getSelectDateStream() => _selectDate;

  PublishSubject<DateTime> getcurrentShowMonthTimeStream() =>
      _currentShowMonthTime;

  void selectDate(DateTime time) {
    _selectDate.add(time);
  }
}
