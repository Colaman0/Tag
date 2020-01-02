import 'package:flutter/material.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

class BuildFlagRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            TextView(
              "预览",
              textColor: Colors.white,
              textSize: 20,
            ).padding(left: 16, right: 16).size(height: View.MATCH).click(() {})
          ],
          title: Text("新建Flag"),
          backgroundColor: HexColor(Constants.MAIN_COLOR),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              selectBg()
            ],
          ),
        ),
      ),
    );
  }

  Widget selectBg() => View(
        child: View(
          child: Icon(Icons.add,size: DP.get(64),color: HexColor(Constants.MAIN_COLOR),),
        )
            .corner(both: 5).margin(both: 8)
            .size(width: View.MATCH, height: 256)
            .backgroundColor(Colors.black12),
      );
}
