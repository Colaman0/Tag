import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tag/bloc/BuildTagBloc.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/imp/basePage.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

class SelectFlagBg extends StatelessWidget with BasePage {
  PublishSubject<File> subject = PublishSubject();
  File _file;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: subject,
      initialData: _file,
      builder: (context, data) {
        return View(
            child: data.data == null
                ? Icon(
              Icons.add,
              size: DP.toDouble(64),
              color: HexColor(Constants.MAIN_COLOR),
            )
                : Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: <Widget>[
                Positioned(
                  child: Image.file(data.data, fit: BoxFit.fitHeight),
                ),
                getDayText(),
                Positioned(
                  right: 0,
                  top: 0,
                  child: View(
                      child: Icon(Icons.clear,
                          size: 16, color: Colors.white))
                      .padding(both: 8)
                      .corner(both: 5)
                      .backgroundColor(Colors.black38)
                      .click(() {
                    subject.add(null);
                  }),
                ),
              ],
            ))
            .corner(both: 5)
            .margin(both: 24)
            .size(width: View.MATCH, height: 256)
            .backgroundColor(Colors.black38)
            .click(() {
          ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
            _file = image;
            if (image != null) {
              subject.add(image);
            }
          });
        });
      },
    );
  }

  Widget getDayText() {
    int day = DateTime
        .now()
        .difference(getTagBloc().getSelectDate())
        .inDays;
    String text = "${day > 0 ? "已经" : "还有"}${day.abs()}天";
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextView(
                  "离",
                  textSize: 40,
                  textColor: Colors.white,
                ),
                Expanded(
                    child: ExpandedEditText(),
                ),
                TextView(
                  "${day > 0 ? "已经" : "还有"}",
                  textSize: 40,
                  textColor: Colors.white,
                )
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Baseline(
                  child: TextView(
                    "${day.abs()}",
                    textSize: 60,
                    textColor: Colors.white,
                  ),
                  baseline: 50,
                  baselineType: TextBaseline.alphabetic,
                ),
                Baseline(
                  child: TextView(
                    "天",
                    textSize: 60,
                    textColor: Colors.white,
                  ),
                  baseline: 50,
                  baselineType: TextBaseline.alphabetic,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  bool dataVaild() => true;

  @override
  String dataTips() {
    // TODO: implement dataTips
    return "";
  }

  @override
  void saveData() {
    // TODO: implement saveData
  }

  @override
  String getFunctionTitle() {
    // TODO: implement getFunctionTitle
    return "选择背景";
  }
}

class ExpandedEditText extends StatefulWidget {
  @override
  _ExpandedEditTextState createState() => _ExpandedEditTextState();
}

class _ExpandedEditTextState extends State<ExpandedEditText> {
  final defalutFontSize = SP.get(60);
  double _fontSize = SP.get(60);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        return TextField(
          onChanged: (text) {
            var size = defalutFontSize;
            // 判断字体长度是否需要换行
            while (IsExpansion(text, box, size, 1)) {
              // 把字号变小
              size -= 2;
            }
            setState(() {
              _fontSize = size;
            });
          },
          maxLines: 1,
          autofocus: true,
          cursorColor: Colors.white,
          style: TextStyle(fontSize: _fontSize, color: Colors.white),
          decoration: InputDecoration(
              fillColor: Colors.white,
              counterText: "",
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.white),
              hintText: ""),
          buildCounter: null,
          textAlign: TextAlign.center,
          maxLength: 10,
        );
      },
    );
  }
}
