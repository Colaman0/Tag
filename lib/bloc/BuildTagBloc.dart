import 'package:rxdart/rxdart.dart';
import 'package:tag/base/bloc.dart';

class BuildTagBloc extends BlocBase {
  PublishSubject<String> _currentFuntion = PublishSubject();
  PublishSubject<int> _currentTime = PublishSubject();

  PublishSubject<String> getFuntionStrStream() => _currentFuntion;
  PublishSubject<int> getSelectTimeStream() => _currentTime;

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
