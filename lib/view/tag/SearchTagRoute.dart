import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tag/entity/BuildTagInfo.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/entity/TodoEntity.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

class SearchTagRoute extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return null;
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<BuildTagInfo>>(
      initialData: [
        BuildTagInfo(tagName: "1234", date: DateTime.now(), todos: [
          TodoEntity(todo: "第一条呢"),
          TodoEntity(todo: "买可乐啊记得！", isFinish: true),
          TodoEntity(todo: "下午打个球", isFinish: false),
        ]),
        BuildTagInfo(tagName: "1234", date: DateTime.now(), todos: [
          TodoEntity(todo: "第一条呢"),
          TodoEntity(todo: "买可乐啊记得！", isFinish: true),
          TodoEntity(todo: "下午打个球", isFinish: false),
          TodoEntity(todo: "123123123123", isFinish: false),
        ])
      ],
      builder: (context, data) {
        List<BuildTagInfo> infos = data.data;
        return View(
          child: ListView.builder(
              padding: EdgeInsets.only(
                  top: DP.toDouble(12), bottom: DP.toDouble(24)),
              itemCount: infos?.length ?? 0,
              itemBuilder: (context, index) {
                BuildTagInfo info = infos[index];
                List<Widget> childs = List();
                childs.add(buildTagTitle(info));
                childs.add(Divider(height: 1));
                childs.addAll(buildTodos(info));
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(DP.toDouble(10)))),
                  margin: EdgeInsets.only(
                      left: DP.toDouble(24),
                      right: DP.toDouble(24),
                      top: DP.toDouble(12)),
                  child: View(
                    child: Column(
                      children: childs,
                    ),
                  ).click(() {}).margin(top: 4),
                );
              }),
        ).backgroundColorStr("#F5F5F5");
      },
    );
  }

  Widget buildTagTitle(BuildTagInfo info) => TextView(
        "${info.date.year}.${info.date.month}月${info.date.day}日 - ${info.date.hour}时${info.date.minute}分",
        textSize: 24,
        textColor: Colors.white,
      )
          .corner(leftTop: 10, rightTop: 10)
          .padding(both: 16)
          .aligment(Alignment.centerLeft)
          .backgroundColorStr(Constants.MAIN_COLOR);

  List<Widget> buildTodos(BuildTagInfo info) {
    List<Widget> widgets = List();
    info.todos.forEach((todo) {
      if (widgets.length >= 3) {
        widgets.add(View(
          child: Icon(Icons.more_vert),
        ).aligment(Alignment.centerLeft).margin(left: 12, bottom: 12));
        return;
      } else {
        widgets.add(
          View(
              child: Row(
            children: <Widget>[
              Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: todo?.isFinish ?? false,
                  activeColor: HexColor(Constants.COLOR_3),
                  checkColor: Colors.white),
              Expanded(
                child: Text(
                  todo?.todo ?? "",
                  style: GoogleFonts.rubik(
                      textStyle: TextStyle(
                    color: todo?.isFinish ?? false
                        ? HexColor(Constants.COLOR_3)
                        : Colors.black,
                    fontSize: SP.get(24),
                    decoration: todo?.isFinish ?? false
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: Colors.grey,
                  )),
                ),
              )
            ],
          )),
        );
      }
    });
    return widgets;
  }
}
