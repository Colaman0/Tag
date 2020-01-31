import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/CategoryManager.dart';
import 'package:tag/util/SelectManager.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/CategroyItemWidget.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

class CategorySearch extends SearchDelegate {
  @override
  String get searchFieldLabel => "搜索";

  @override
  Color get cursorColor => Colors.white;

  SelectManager _selectManager;

  /// 允许选中的最大数量
  final maxSize;

  CategorySearch(this.maxSize) {
    _selectManager = SelectManager(maxSize: maxSize, lowSize: 0);
  }

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
        List<CategoryItemWidget> items;
        if (categories != null && categories.isNotEmpty && query.isNotEmpty) {
          /// 匹配现有的分类标记，加到results中去
          categories.forEach((name) {
            if (name.contains(query)) {
              results.add(name);
            }
          });
          items =
              results.map((name) => CategoryItemWidget(name: name)).toList();
          _selectManager.updateDatas(items, removeSelect: true);
        }

        return Container(
          padding: EdgeInsets.all(DP.get(32)),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  runAlignment: WrapAlignment.start,
                  children: items ?? [],
                  spacing: DP.get(16),
                ),
                Spacer(),
                getConfirmButton(context)
              ]),
        );
      },
    );
  }

  Widget getConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: DP.get(70),
      child: RaisedButton.icon(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(DP.get(12)))),
        color: HexColor("#13547a"),
        icon: Container(),
        label: TextView(
          "确定",
          textColor: Colors.white,
          textSize: 24,
        ),
        onPressed: () {
          close(context, _selectManager.getSelectResults());
        },
      ),
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
