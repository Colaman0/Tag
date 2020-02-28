import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/SelectManager.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

class CategoryItemWidget extends StatelessWidget with SelectItem {
  final String name;
  final bool clickAble;
  final bool removeAble;
  final Function removeCallback;
  final PublishSubject<bool> selectStream = PublishSubject();

  CategoryItemWidget(
      {Key key,
      this.name,
      this.clickAble = true,
      this.removeCallback,
      this.removeAble = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: false,
      stream: selectStream,
      builder: (context, data) {
        return GestureDetector(
          child: Chip(
              padding: EdgeInsets.all(DP.toDouble(8)),
              deleteButtonTooltipMessage: "移除",
              backgroundColor: getCurrentSelectStatus()
                  ? HexColor("#00adb5")
                  : HexColor(Constants.MAIN_COLOR),
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
                      size: DP.toDouble(28),
                    ))
                  : null,
              label: Text(name,
                  style: TextView.getDefaultStyle(
                      fontSize: SP.get(26),
                      textColor: data.data ? Colors.white : Colors.white))),
          onTap: () {
            if (clickAble) {
              getSelectManager().checkItem(this);
            }
          },
        );
      },
    );
  }

  @override
  void changeStatus(bool isSelect) {
    // TODO: implement changeStatus
    super.changeStatus(isSelect);
    selectStream.add(isSelect);
  }

  @override
  getItemKey() {
    // TODO: implement getItemKey
    return name;
  }
}
