import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tag/entity/BuildFlagInfo.dart';
import 'package:tag/entity/BuildTagInfo.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/entity/TodoEntity.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/CategroyItemWidget.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

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
            flagName: "林世杰生日",
            date: DateTime.now(),
            categories: ["知识", "改变", '命运'])
      ],
      builder: (context, data) {
        List<BuildFlagInfo> infos = data.data;
        return View(
          child: ListView.builder(
              padding: EdgeInsets.only(
                  top: DP.toDouble(12), bottom: DP.toDouble(24)),
              itemCount: infos?.length ?? 0,
              itemBuilder: (context, index) {
                BuildFlagInfo info = infos[index];
                return View(
                        child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 0,
                      right: 0,
                      top: DP.toDouble(108),
                      child: Wrap(
                        runAlignment: WrapAlignment.start,
                        children: info.categories
                            .map((tagName) => Card(
                                child: TextView(
                                  tagName,
                                  textColor: Colors.white,
                                )
                                    .aligment(null)
                                    .backgroundColorStr(Constants.COLOR_BLUE)
                                    .corner(leftBottom: 5, rightBottom: 5)
                                    .padding(
                                        left: 12, right: 12, top: 8, bottom: 8)
                                    .size(width: View.WRAP, height: View.WRAP),
                                elevation: 8))
                            .toList(),
                        spacing: DP.toDouble(8),
                      ),
                    ),
                    Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: View(
                          child: Card(
                            elevation: 5,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                buildTitle(info),
                                Flexible(
                                  flex: 1,
                                  child: buildFlagNameWidget(info),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: buildFlagNameWidget(info),
                                ),
                              ],
                            ),
                          ),
                        ).size(width: View.MATCH, height: 200)),
                  ],
                ))
                    .click(() {})
                    .size(width: View.MATCH, height: 200)
                    .margin(both: 12);
              }),
        ).backgroundColorStr("#F5F5F5");
      },
    );
  }

  Widget buildTitle(BuildFlagInfo info) => View(
        child: Row(
          children: <Widget>[
            Icon(Icons.calendar_today,
                color: Colors.white, size: DP.toDouble(24)),
            TextView(
              "${info.date.year}.${info.date.month}月${info.date.day}日 - ${info.date.hour}时${info.date.minute}分",
              textSize: 26,
              textColor: Colors.white,
            ).margin(left: 12)
          ],
        ),
      )
          .corner(leftTop: 10, rightTop: 10)
          .padding(both: 16)
          .aligment(Alignment.centerLeft)
          .backgroundColorStr(Constants.MAIN_COLOR);

  Widget buildFlagNameWidget(BuildFlagInfo info) => TextView(
        info.flagName,
        textSize: 30,
        textColor: HexColor(Constants.MAIN_COLOR),
      );
}
