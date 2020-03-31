import 'package:flutter/material.dart';
import 'package:tag/entity/BuildTagInfo.dart';
import 'package:tag/util/DataProvider.dart';
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
      future: DataProvider.getInstance().searchTag(query),
      builder: (context, data) {
        return TagListWidget(
          infos: data.data,
        );
      },
    );
  }
}
