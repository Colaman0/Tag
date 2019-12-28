class DoubleClickUtil {
  var lastClickTime = 0;
  Function callback;

  void registerCallback(Function(bool) callback) {
    this.callback = callback;
  }

  void click() {
    var now = DateTime.now().millisecondsSinceEpoch;
    if (now - lastClickTime < 500) {
      callback(true);
    } else {
      callback(false);
    }
    lastClickTime = now;
  }
}
