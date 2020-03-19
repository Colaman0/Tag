import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tag/entity/BuildFlagInfo.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

class FlagListWidget extends StatefulWidget {
  List<BuildFlagInfo> infos = List();

  FlagListWidget({this.infos});

  @override
  _FlagListWidgetState createState() => _FlagListWidgetState();
}

class _FlagListWidgetState extends State<FlagListWidget> {
  String titleColor = "#2a7886";
  String dayColor = "#79bac1";
  String tagColor = "#2a7886";

  @override
  Widget build(BuildContext context) {
    return View(
      child: ListView.builder(
          padding:
              EdgeInsets.only(top: DP.toDouble(12), bottom: DP.toDouble(24)),
          itemCount: widget.infos?.length ?? 0,
          itemBuilder: (context, index) {
            BuildFlagInfo info = widget.infos[index];
            return View(
                    child: Stack(
              children: <Widget>[
                Positioned(
                  left: 0,
                  right: 0,
                  top: DP.toDouble(120),
                  child: Wrap(
                    runAlignment: WrapAlignment.start,
                    children: info.categories
                        .map((tagName) => Card(
                      child: TextView(
                        tagName,
                        textColor: Colors.white,
                      )
                          .aligment(null)
                          .backgroundColorStr(tagColor)
                          .corner(leftBottom: 5, rightBottom: 5)
                          .padding(
                          left: 12, right: 12, top: 8, bottom: 8)
                          .size(width: View.WRAP, height: View.WRAP),
                      elevation: 3,
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
                        color: Colors.transparent,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  View(
                                    child: Row(
                                      children: <Widget>[
                                        View(
                                          child: Icon(
                                            Icons.today,
                                            color: Colors.white,
                                            size: DP.toDouble(26),
                                          ),
                                        ).margin(left: 12),
                                        TextView(
                                          "2019年3月7日",
                                          textSize: 24,
                                          textColor: Colors.white,
                                        )
                                            .aligment(Alignment.centerLeft)
                                            .padding(left: 12, right: 12),
                                      ],
                                    ),
                                  )
                                      .backgroundColorStr(titleColor)
                                      .size(width: View.MATCH)
                                      .corner(leftTop: 8),
                                  Divider(
                                    height: 1,
                                    color: HexColor(Constants.COLOR_BLUE),
                                  ),
                                  Expanded(
                                      child: TextView(
                                    info.flagName + "还有",
                                    textSize: 30,
                                    textColor: Colors.black,
                                  )
                                          .backgroundColor(Colors.white)
                                          .aligment(Alignment.centerLeft)
                                          .padding(left: 12, right: 12)),
                                ],
                              ),
                            ),
                            View(
                              child: buildDayText("123"),
                            )
                                .size(width: 120, height: View.MATCH)
                                .backgroundColorStr(dayColor)
                                .corner(rightTop: 8, rightBottom: 8)
                          ],
                        ),
                      ),
                    ).size(width: View.MATCH, height: 130).margin(bottom: 20)),
              ],
            ))
                .click(() {})
                .size(width: View.MATCH, height: 170)
                .margin(both: 12);
          }),
    ).backgroundColorStr("#F5F5F5");
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
