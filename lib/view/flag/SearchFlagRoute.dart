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
            flagName: "距离林世杰生日",
            date: DateTime.now(),
            categories: ["生日", "自己"]),
        BuildFlagInfo(
            flagName: "距离林XX生日", date: DateTime.now(), categories: ["恩啊"])
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
                      top: DP.toDouble(110),
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
                                          left: 12,
                                          right: 12,
                                          top: 8,
                                          bottom: 8)
                                      .size(
                                          width: View.WRAP, height: View.WRAP),
                                  elevation: 5,
                                ))
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
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          View(
                                            child: Icon(Icons.today,color: HexColor(Constants.COLOR_BLUE),size: DP.toDouble(26),),
                                          ).margin(left: 12),
                                          TextView("2019年3月7日",
                                                  textSize: 24,
                                                  textColorStr:
                                                      Constants.COLOR_BLUE)
                                              .aligment(Alignment.centerLeft)
                                              .margin(left: 12, right: 12),
                                        ],
                                      ),
                                      Divider(
                                        height: 1,
                                        color: HexColor(Constants.COLOR_BLUE),
                                      ),
                                      Expanded(
                                        child: TextView(info.flagName + "还有",
                                                textSize: 30,
                                                textColorStr:
                                                    Constants.MAIN_COLOR)
                                            .aligment(Alignment.centerLeft)
                                            .margin(left: 12, right: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                View(
                                  child: buildDayText("123"),
                                )
                                    .size(width: 120, height: View.MATCH)
                                    .backgroundColorStr(Constants.COLOR_BLUE)
                              ],
                            ),
                          ),
                        ).size(width: View.MATCH, height: 120)),
                  ],
                ))
                    .click(() {})
                    .size(width: View.MATCH, height: 160)
                    .margin(both: 12);
              }),
        ).backgroundColorStr("#F5F5F5");
      },
    );
  }

  Widget buildDayText(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textBaseline: TextBaseline.alphabetic,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: <Widget>[
        Expanded(
          child: LayoutBuilder(
            builder: (builder, box) {
              double fontSize = calculateAutoscaleFontSize(
                  text,
                  GoogleFonts.rubik(),
                  SP.get(28),
                  box.maxWidth - DP.toDouble(12));
              return Container(
                child: Baseline(
                  child: Text(text,
                      softWrap: false,
                      style: GoogleFonts.rubik(
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: fontSize),
                      )),
                  baselineType: TextBaseline.alphabetic,
                  baseline: DP.toDouble(50),
                ),
                margin: EdgeInsets.only(
                    left: DP.toDouble(12), right: DP.toDouble(4)),
              );
            },
          ),
        ),
        Padding(
          child: Baseline(
            child: Text("天",
                style: GoogleFonts.rubik(
                  textStyle:
                      TextStyle(color: Colors.white, fontSize: SP.get(20)),
                )),
            baseline: DP.toDouble(50),
            baselineType: TextBaseline.alphabetic,
          ),
          padding: EdgeInsets.only(right: 8),
        )
      ],
    );
  }

  Widget buildTitle(BuildFlagInfo info) => View(
        child: Row(
          children: <Widget>[
            Icon(Icons.calendar_today,
                color: Colors.white, size: DP.toDouble(24)),
            TextView(
              "${info.date.year}.${info.date.month}.${info.date.day}",
              textSize: 26,
              textColor: Colors.black,
            ).margin(left: 12)
          ],
        ),
      )
          .corner(leftTop: 10, rightTop: 10)
          .padding(both: 16)
          .aligment(Alignment.centerLeft);

  Widget buildFlagNameWidget(BuildFlagInfo info) => TextView(
        info.flagName,
        textSize: 30,
        textColor: HexColor(Constants.MAIN_COLOR),
      );

  bool IsExpansion(String text, BoxConstraints constraints, fontSize) {
    TextPainter _textPainter = TextPainter(
        maxLines: 1,
        text: TextSpan(
            text: text,
            style: TextStyle(color: Colors.black, fontSize: fontSize)),
        textDirection: TextDirection.ltr)
      ..layout(maxWidth: constraints.maxWidth, minWidth: constraints.minWidth);
    return _textPainter.didExceedMaxLines;
  }

  double calculateAutoscaleFontSize(
      String text, TextStyle style, double startFontSize, double maxWidth) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    var currentFontSize = startFontSize;

    while (true) {
      final nextFontSize = currentFontSize + 1;
      final nextTextStyle = style.copyWith(fontSize: nextFontSize);
      textPainter.text = TextSpan(text: text, style: nextTextStyle);
      textPainter.layout();
      if (textPainter.width >= maxWidth) {
        return currentFontSize;
      } else {
        currentFontSize = nextFontSize;
      }
    }
  }
}
