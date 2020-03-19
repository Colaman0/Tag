import 'package:flutter/material.dart';
import 'package:tag/entity/BuildFlagInfo.dart';
import 'package:tag/view/flag/FlagListWidget.dart';

class SearchFlagRoute extends SearchDelegate {
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
    return FutureBuilder<List<BuildFlagInfo>>(
      initialData: [
        BuildFlagInfo(
            flagName: "距离林世杰生日",
            date: DateTime.now(),
            categories: ["生日", "自己"]),
        BuildFlagInfo(
            flagName: "距离林XX生日", date: DateTime.now(), categories: ["恩啊"])
      ],
      builder: (context, data) {
        List<BuildFlagInfo> infos = data.data;
        return FlagListWidget(infos: infos);
      },
    );
  }
}
