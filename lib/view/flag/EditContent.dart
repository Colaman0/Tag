import 'package:flutter/material.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/imp/basePage.dart';
import 'package:tag/view/widget/view/View.dart';

class EditContent extends StatelessWidget with BasePage {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        View(
          child: Card(
            elevation: 5,
            child: Column(
              children: <Widget>[
                View(
                  child: TextField(
                    maxLength: 20,
                    buildCounter: null,
                    autofocus: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      counterText: "",
                      hintText: "请输入Flag标题",
                    ),
                  ),
                )
                    .margin(left: 16, right: 16)
                    .padding(both: 8)
                    .corner(both: 5)
                    .storke(color: Constants.MAIN_COLOR, width: 1)
              ],
            ),
          ),
        ).margin(both: 16)
      ],
    );
  }

  @override
  String dataTips() {
    // TODO: implement dataTips
    return null;
  }

  @override
  bool dataVaild() {
    // TODO: implement dataVaild
    return null;
  }
}
