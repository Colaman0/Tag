import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/View.dart';

class TimeTagRoute extends StatefulWidget {
  @override
  _TimeTagRouteState createState() => _TimeTagRouteState();
}

class _TimeTagRouteState extends State<TimeTagRoute> {
  @override
  Widget build(BuildContext context) {
    var text = "121";

    return SafeArea(
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: DP.toDouble(32),
              child: Text("下一个 Tag",
                  softWrap: false,
                  style: GoogleFonts.rubik(
                    textStyle: TextStyle(
                        color: HexColor(Constants.MAIN_COLOR),
                        fontSize: SP.get(32)),
                  ))),
          Positioned(
            child: Container(
              child: Row(
                textBaseline: TextBaseline.alphabetic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: <Widget>[
                  Expanded(
                    child: LayoutBuilder(
                      builder: (builder, box) {
                        double fontSize = calculateAutoscaleFontSize(text,
                            GoogleFonts.rubik(), 20, box.maxWidth - DP.toDouble(64));
                        return Container(
                          margin: EdgeInsets.only(
                              left: DP.toDouble(32), right: DP.toDouble(32)),
                          child: Baseline(
                            child: Text(text,
                                softWrap: false,
                                style: GoogleFonts.rubik(
                                  textStyle: TextStyle(
                                      color: HexColor(Constants.MAIN_COLOR),
                                      fontSize: fontSize),
                                )),
                            baselineType: TextBaseline.alphabetic,
                            baseline: DP.toDouble(128),
                          ),
                        );
                      },
                    ),
                  ),
                  View(
                      child: Baseline(
                    child: Text("天",
                        style: GoogleFonts.rubik(
                          textStyle: TextStyle(
                              color: HexColor(Constants.MAIN_COLOR),
                              fontSize: 40),
                        )),
                    baseline: DP.toDouble(128),
                    baselineType: TextBaseline.alphabetic,
                  )).margin(right: 32).backgroundColor(Colors.white)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
