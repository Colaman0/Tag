import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:tag/base/bloc.dart';
import 'package:tag/bloc/BuildTagBloc.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/StatusBar.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

class BuildTagRoute extends StatelessWidget {
  BuildTagBloc _bloc = BuildTagBloc();

  Color mainColor = HexColor(Constants.MAIN_COLOR);

  @override
  Widget build(BuildContext context) {
    return StatusBar(
      color: HexColor(Constants.MAIN_COLOR),
        child: BlocProvider(
      bloc: _bloc,
      child: Container(
        color: mainColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            View(
              child:
                  Icon(Icons.arrow_back, size: DP.get(48), color: Colors.white),
            ).size(width: 64, height: 64).click(() {
              Navigator.of(context).pop();
            }),
            StreamBuilder(
              initialData: "选择日期",
              stream: _bloc.getFuntionStrStream(),
              builder: (context, data) => TextView(
                data.data,
                textSize: 36,
                textColor: Colors.white,
              ).aligment(Alignment.centerLeft).margin(left: 16, top: 16),
            ),
            Expanded(
              child: View(
                child: PageView(),
              )
                  .size(width: View.MATCH, height: View.MATCH)
                  .corner(leftTop: 24, rightTop: 24)
                  .margin(top: 48)
                  .backgroundColor(Colors.white),
            )
          ],
        ),
      ),
    ));
  }

  Widget getTitles() {
    return Row(
      children: <Widget>[],
    );
  }
}
