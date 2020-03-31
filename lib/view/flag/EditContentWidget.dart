import 'package:flutter/material.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/imp/basePage.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/TextView.dart';

/// 编辑Flag
class EditFlagContentWidget extends StatelessWidget with BasePage {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(DP.toDouble(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextView(
              "Flag标题",
              textSize: 28,
              textColor: Colors.grey,
            ).aligment(Alignment.centerLeft).margin(bottom: 4),
            TextField(
              autofocus: true,
              maxLines: 1,
              maxLength: 10,
              style: TextStyle(color: Colors.black, fontSize: SP.get(28)),
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.subtitles),
                  border: InputBorder.none,
                  hintText: "输入标题",
                  hintStyle:
                      TextStyle(color: Colors.white, fontSize: SP.get(28))),
            )
          ],
        ),
      ),
    );
  }

  @override
  String dataTips() {
    // TODO: implement dataTips
    return "";
  }

  @override
  bool dataVaild() {
    // TODO: implement dataVaild
    return true;
  }

  @override
  String getFunctionTitle() {
    // TODO: implement getFunctionTitle
    return "编辑Flag";
  }

  @override
  void saveData() {
    // TODO: implement saveData
  }
}
