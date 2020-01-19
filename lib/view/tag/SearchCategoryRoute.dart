import 'package:flutter/material.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/CategoryManager.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/TextView.dart';

class SearchCategoryRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}

class CategorySearch extends SearchDelegate {
  @override
  String get searchFieldLabel => "搜索";

  @override
  Color get cursorColor => Colors.white;

  /// 允许选中的最大数量
  final maxSize;

  CategorySearch(this.maxSize);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      )
    ];
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
    return FutureBuilder<List<String>>(
      future: CategoryManager.getInstance().getAllCategory(),
      builder: (context, data) {
        List<String> categories = data.data;
        List<String> results = [];

        /// 匹配现有的分类标记，加到results中去
        categories.forEach((name) {
          if (name.contains(query)) {
            results.add(name);
          }
        });
        return TextView(data.data[query.length]);
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      textTheme: TextTheme(
          title: TextView.getDefaultStyle(
              fontSize: SP.get(22), textColor: Colors.white)),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextView.getDefaultStyle(
            fontSize: SP.get(22), textColor: Colors.white),
      ),
      primaryColor: HexColor(Constants.MAIN_COLOR),
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.white),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: TextTheme(
          title: TextStyle(backgroundColor: Colors.white, color: Colors.white)),
    );
  }
}
