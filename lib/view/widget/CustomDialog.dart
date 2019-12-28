import 'package:flutter/material.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/BaseWidget.dart';
import 'package:tag/view/widget/view/View.dart';


class CustomDialog extends StatefulWidget {
  final Widget childWidget;

  const CustomDialog({Key key, this.childWidget}) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState(childWidget);
}

class _CustomDialogState extends State<CustomDialog> {
  final Widget childWidget;

  _CustomDialogState(this.childWidget);

  @override
  Widget build(BuildContext context) {
    Duration insetAnimationDuration = const Duration(milliseconds: 100);
    Curve insetAnimationCurve = Curves.decelerate;

    RoundedRectangleBorder _defaultDialogShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)));

    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: View(
          child: Center(
            child: Material(
              color: Colors.black,
              type: MaterialType.card,
              //在这里修改成我们想要显示的widget就行了，外部的属性跟其他Dialog保持一致
              child: childWidget,
            ),
          ),
        ).size(width: View.MATCH, height: View.MATCH),
      ),
    );
  }
}
