import 'package:rxdart/rxdart.dart';
import 'package:tag/base/bloc.dart';

class BuildTagBloc extends BlocBase {
  PublishSubject<String> _currentFuntion = PublishSubject();
  PublishSubject<int> _currentTime = PublishSubject();
  PublishSubject<DateTime> _selectDateStream = PublishSubject();

  PublishSubject<String> getFuntionStrStream() => _currentFuntion;

  PublishSubject<int> getSelectTimeStream() => _currentTime;

  PublishSubject<DateTime> getSelectDateStream() => _selectDateStream;
  DateTime _selectDateTime;

  void selectDate(DateTime dateTime) {
    _selectDateTime = dateTime;
  }

  DateTime getSelectDate() => _selectDateTime;

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
