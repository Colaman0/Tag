import 'package:rxdart/rxdart.dart';
import 'package:tag/base/bloc.dart';

class BuildFlagBloc extends BlocBase {
  PublishSubject<DateTime> _selectDate = PublishSubject();

  PublishSubject<DateTime> getSelectDateStream() => _selectDate;

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
