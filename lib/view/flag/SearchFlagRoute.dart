import 'package:flutter/material.dart';
import 'package:tag/entity/BuildFlagInfo.dart';
import 'package:tag/util/DataProvider.dart';
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
      future: DataProvider.getInstance().searchFlag(query),
      builder: (context, data) {
        return FlagListWidget(infos: data.data);
      },
    );
  }
}
