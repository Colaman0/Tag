import 'package:rxdart/rxdart.dart';

abstract class Bindable<T> {
  Subject<T> _stream;

  Subject<T> getBindChangeStream() => _stream;

  void injectStream(Subject<T> stream) {
    _stream = stream;
  }

  void onBind(T data);

  void dipose() {
    if (_stream != null && !_stream.isClosed) {
      _stream.close();
    }
  }
}

class Bind {
  static void bind<T>(Bindable<T> bindable1, Bindable<T> bindable2) {
    PublishSubject subject = PublishSubject<T>();
    bindable1.injectStream(subject as Subject<T>);
    bindable2.injectStream(subject as Subject<T>);
  }
}
