import 'package:tag/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tag/view/widget/view/View.dart';

import 'BaseWidget.dart';

///
/// * Author    : kyle
/// * Time      : 2019/9/10
/// * Function  : 封装Widget，作为一个单独使用的Radio，并且添加回调和基础配置
///
typedef Callback = Function(bool);

class RadioButtoin extends StatefulWidget {
  Callback _callback;
  bool _value;
  Color _selectColor;
  Color _unselectColor;
  IconData _selectIcon, _unselectIcon;
  View _layout;

  RadioButtoin(
      {View layout,
      Color selectColor,
      Color unselectColor,
      bool value,
      Callback callback,
      IconData selectIcon,
      IconData unselectIcon}) {
    _value = value ?? false;
    if (_callback == null) {
      _callback = (_) {};
    }
    _layout = layout;
    _selectColor = selectColor;
    _unselectColor = unselectColor;
    _selectIcon = selectIcon;
    _unselectIcon = unselectIcon;
  }

  @override
  _TouchRadioState createState() => _TouchRadioState();
}

class _TouchRadioState extends State<RadioButtoin> {
  @override
  Widget build(BuildContext context) {
    IconData icon;
    if (widget._selectIcon != null && widget._unselectIcon != null) {
      icon = widget._value ? widget._selectIcon : widget._unselectIcon;
    } else {
      icon = widget._value ? Icons.radio_button_checked : Icons.radio_button_unchecked;
    }
    Color color = widget._value ? widget._selectColor ?? Colors.blueAccent : widget._unselectColor ?? Colors.grey;
    return AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: View(
          child: IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              icon,
              color: color,
              size: DP.get(8),
            ),
            onPressed: () {
              setState(() {
                widget._value = !widget._value;
                if (widget._callback != null) {
                  widget._callback(widget._value);
                }
              });
            },
          ),
          key: ValueKey(icon),
        ).size(width: 8, height: 8));
  }
}
