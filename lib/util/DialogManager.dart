import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tag/view/widget/BaseWidget.dart';
import 'package:tag/view/widget/view/View.dart';

class DialogManager {
  static DialogManager _instance;

  DialogManager._();

  static DialogManager getInstance() {
    if (_instance == null) {
      _instance = DialogManager._();
    }
    return _instance;
  }

  /// 展示loading
  void showLoadingDialog(BuildContext context) {
    showDialog(
        builder: (_) => WillPopScope(
            onWillPop: () => Future.value(false),
            child: Center(
              child: View(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              )).size(width: 200, height: 200).backgroundColor(Colors.black38).corner(both: 5),
            )),
        barrierDismissible: false,
        context: context);
  }

  /// 隐藏当前页面的dialog
  void dismissDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
