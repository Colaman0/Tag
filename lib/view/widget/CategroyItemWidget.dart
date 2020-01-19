import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

class CategoryItemWidget extends StatelessWidget {
  final String name;
  final bool clickAble;
  final bool removeAble;

  final Function removeCallback;

  PublishSubject<bool> selectStream = PublishSubject();

  CategoryItemWidget(
      {Key key,
      this.name,
      this.clickAble = false,
      this.removeCallback,
      this.removeAble = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context, data) {
        return Chip(
            padding: EdgeInsets.all(DP.get(8)),
            deleteButtonTooltipMessage: "移除",
            backgroundColor: HexColor(Constants.MAIN_COLOR),
            onDeleted: removeAble
                ? () {
                    if (removeCallback != null) {
                      removeCallback(name);
                    }
                  }
                : null,
            deleteIcon: removeAble
                ? View(
                    child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: DP.get(28),
                  ))
                : null,
            label: Text(name,
                style: TextView.getDefaultStyle(
                    fontSize: SP.get(26), textColor: Colors.white)));
      },
    );
  }
}
