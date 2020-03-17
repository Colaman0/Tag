import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/entity/TodoEntity.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/View.dart';

/// todo的item控件，用于展示清单列表的内容
class TodoItemWidget extends StatefulWidget {
  /// 当前todo是否完成
  bool isFinish = false;

  /// todo具体内容
  String todo = "";

  final TodoEntity todoEntity;

  VoidCallback voidCallback;

  TodoItemWidget({Key key, this.todoEntity, this.voidCallback})
      : super(key: key) {
    /// 初始化数据
    isFinish = todoEntity?.isFinish ?? false;
    todo = todoEntity?.todo ?? '';
  }

  TodoEntity getTodoEntity() {
    return todoEntity;
  }

  @override
  _TodoItemWidgetState createState() {
    return _TodoItemWidgetState();
  }
}

class _TodoItemWidgetState extends State<TodoItemWidget> {
  @override
  Widget build(BuildContext context) {
    return View(
        child: Row(
      children: <Widget>[
        Checkbox(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: widget?.todoEntity?.isFinish ?? false,
          activeColor: HexColor(Constants.COLOR_3),
          checkColor: Colors.white,
          onChanged: widget?.voidCallback == null
              ? null
              : (select) {
                  setState(() {
                    widget?.todoEntity?.isFinish = select;
                    widget?.voidCallback();
                  });
                },
        ),
        Expanded(
          child: Text(
            widget?.todoEntity?.todo ?? "",
            style: GoogleFonts.rubik(
                textStyle: TextStyle(
              color: widget?.todoEntity?.isFinish ?? false
                  ? HexColor(Constants.COLOR_3)
                  : Colors.black,
              fontSize: SP.get(28),
              decoration: widget?.todoEntity?.isFinish ?? false
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              decorationColor: Colors.grey,
            )),
          ),
        )
      ],
    )).padding(both: 12).click(() {
      setState(() {
        widget?.todoEntity?.isFinish = !(widget?.todoEntity?.isFinish ?? false);
        widget?.voidCallback();
      });
    });
  }
}
