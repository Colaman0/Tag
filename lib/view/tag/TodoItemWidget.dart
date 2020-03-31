import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tag/base/bloc.dart';
import 'package:tag/bloc/BuildTagBloc.dart';
import 'package:tag/entity/BuildTagInfo.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/View.dart';

/// todo的item控件，用于展示清单列表的内容
class TodoItemWidget extends StatefulWidget {
  /// 当前todo是否完成
  bool isFinish = false;

  /// todo具体内容
  String todo = "";

  final Todo todoEntity;

  Function voidCallback;

  TodoItemWidget({Key key, this.todoEntity, this.voidCallback})
      : super(key: key) {
    /// 初始化数据
    isFinish = todoEntity?.isTodoFinish() ?? false;
    todo = todoEntity?.name ?? '';
  }

  Todo getTodoEntity() {
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
          value: widget?.todoEntity?.isTodoFinish() ?? false,
          activeColor: HexColor(Constants.COLOR_3),
          checkColor: Colors.white,
          onChanged: widget?.voidCallback == null
              ? null
              : (select) {
                  BuildTagBloc bloc = BlocProvider.of(context);
                  widget?.todoEntity?.setFinish(select);
                  bloc.updateTag((result) {
                    if (result) {
                      setState(() {
                        widget?.todoEntity?.setFinish(select);
                        widget?.voidCallback();
                      });
                    } else {
                      widget?.todoEntity?.setFinish(!select);
                      Fluttertoast.showToast(msg: "网络错误");
                    }
                  });
                },
        ),
        Expanded(
          child: Text(
            widget?.todoEntity?.name ?? "",
            style: GoogleFonts.rubik(
                textStyle: TextStyle(
              color: widget?.todoEntity?.isTodoFinish() ?? false
                  ? HexColor(Constants.COLOR_3)
                  : Colors.black,
              fontSize: SP.get(28),
              decoration: widget?.todoEntity?.isTodoFinish() ?? false
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              decorationColor: Colors.grey,
            )),
          ),
        )
      ],
    )).padding(both: 12).click(() {
      setState(() {
        widget?.todoEntity
            ?.setFinish(!(widget?.todoEntity?.isTodoFinish() ?? false));
        widget?.voidCallback();
      });
    });
  }
}
