import 'package:tag/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'View.dart';

///
/// * Author    : kyle
/// * Time      : 2019/9/10
/// * Function  :
///

class TextView extends View {
  final String content;
  final int textSize;
  final String textColorStr;
  Color textColor;

  TextView(this.content, {this.textSize, this.textColorStr, this.textColor});

  @override
  Widget initChild() {
    /// 设置字体颜色
    if (textColorStr != null && textColorStr.isNotEmpty) {
      textColor = HexColor(textColorStr);
    }
    if (textColor == null) {
      textColor = Colors.black;
    }
    return Text(content,
        softWrap: true,
        style: TextStyle(fontSize: SP.get(textSize ?? 18), color: textColor, decoration: TextDecoration.none));
  }
}
