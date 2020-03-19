import 'package:flutter/material.dart';
import 'package:tag/entity/BuildTagInfo.dart';
import 'package:tag/entity/TodoEntity.dart';
import 'package:tag/view/tag/TagListWidget.dart';

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
        return TagListWidget(
          infos: infos,
        );
      },
    );
  }
}
