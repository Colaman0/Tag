import 'package:flutter/cupertino.dart';
import 'package:tag/entity/BuildTagInfo.dart';
import 'package:tag/entity/TodoEntity.dart';
import 'package:tag/view/flag/FlagListWidget.dart';
import 'package:tag/view/tag/TagListWidget.dart';

/// 首页tag列表的widget
class HomeTagListWidget extends StatefulWidget {
  @override
  _HomeTagListWidgetState createState() => _HomeTagListWidgetState();
}

class _HomeTagListWidgetState extends State<HomeTagListWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BuildTagInfo>>(
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
        return TagListWidget(infos: infos);
      },
    );
  }
}
