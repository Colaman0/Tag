import 'package:rxdart/rxdart.dart';
import 'package:tag/base/bloc.dart';

class BuildTagBloc extends BlocBase {
  PublishSubject<String> _currentFuntion = PublishSubject();

  PublishSubject<String> getFuntionStrStream() => _currentFuntion;

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
