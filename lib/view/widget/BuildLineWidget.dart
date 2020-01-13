import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/View.dart';

class BuildLineWidget extends StatelessWidget {
  final List<Widget> childs;
  final PublishSubject stream;
  int lineHeight = 2;
  int pointSize = 12;

  BuildLineWidget(this.childs, this.stream);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      List<Widget> titles = List();

      childs.forEach((widget) => titles.add(Expanded(child: View(child: widget).aligment(Alignment.center))));

      return Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: DP.get(4),bottom: DP.get(8)),
              child: Row(
                children: titles,
              ),
            ),
            StreamBuilder(
              initialData: 0,
              stream: stream,
              builder: (context, data) {
                return getBaseLine(context, box, data.data);
              },
            )
          ],
        ),
        padding: EdgeInsets.only(top: DP.get(8), bottom: DP.get(8)),
      );
    });
  }

  Widget getBaseLine(BuildContext buildcontext, BoxConstraints box, int position) {
    _currentProgress = position;
    List<Widget> children = List();
    int length = childs.length;
    int pointSize = 16;

    for (int i = 0; i < length; i++) {
      children.add(Expanded(
          child: View()
              .backgroundColor(i == 0 ? Colors.transparent : getLineColor(i))
              .size(width: View.MATCH, height: lineHeight)));

      children.add(View().circle().size(width: pointSize).backgroundColor(getPointColor(i)));

      children.add(Expanded(
          child: View()
              .size(width: View.MATCH, height: lineHeight)
              .backgroundColor(i == length - 1 ? Colors.transparent : getLineColor(i))));
    }
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: children,
    );
  }

  String color = Constants.COLOR_BLUE;


  Color getPointColor(int position) => position <= _currentProgress ? HexColor(color) : HexColor(Constants.COLOR_3);

  Color getLineColor(int position) => position <= _currentProgress ? HexColor(color) : HexColor(Constants.COLOR_3);

  int _currentProgress = 0;

  Size getSize(BuildContext context) => context.size;
}
