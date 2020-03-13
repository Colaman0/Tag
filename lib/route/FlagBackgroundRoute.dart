import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tag/entity/BuildFlagInfo.dart';
import 'package:tag/entity/BuildFlagInfo.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/NaigatorUtils.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

class FlagBackgroundRoute extends StatelessWidget {
  /// 背景图片文件流
  PublishSubject<BuildFlagInfo> backgroundStream;

  BuildFlagInfo info;

  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    init(context);
    backgroundStream = PublishSubject();

    /// 把页面UI完善一下，生成一个widget list
    List<Widget> positions =
        getFlagContentWidgets(info, backgroundStream: backgroundStream);
    positions.add(getTouchTips(context));
    positions.add(getAppbar(context));

    return Scaffold(
      body: Builder(
        builder: (context) {
          _context = context;
          return Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: positions,
          );
        },
      ),
    );
  }

  void init(BuildContext context) {
    if (info == null) {
      /// 拿到上一页传过来info
      info = NavigatorUtils.getPreArguments(context)[Constants.DATA];
    }
  }

  /// 顶部标题栏
  Widget getAppbar(BuildContext context) {
    return Positioned(
      top: ScreenUtil.statusBarHeight,
      left: 0,
      right: 0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: DP.toDouble(36),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Spacer(),
          TextView("确定", textSize: 24, textColor: Colors.white)
              .padding(both: 16)
              .click(() {
            /// 跳转到Flag页面
            NavigatorUtils.getInstance().toFlagRoute(context, info);
          })
        ],
      ),
    );
  }

  Widget getDateContent() {
    return Positioned(
        left: 0,
        right: 0,
        bottom: DP.toDouble(240),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.date_range,
              color: Colors.white,
            ),
            SizedBox(
              width: DP.toDouble(8),
            ),
            Text(
              "${info.date.year}年${info.date.month}月${info.date.day}日${info.date.hour}时${info.date.minute}分",
              style: new TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                textBaseline: TextBaseline.alphabetic,
              ),
            )
          ],
        ));
  }

  Widget getFlagTitle() {
    String title = "距离${info.flagName}"
        "${DateTime.now().isAfter(info.date) ? "已经" : "还有"}";

    return Positioned(
        left: 0,
        right: 0,
        top: DP.toDouble(240),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            title,
            style: new TextStyle(
              fontSize: 30.0,
              color: Colors.white,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
        ));
  }

  Widget getFlagBody() {
    return Positioned(
        child: StreamBuilder(
      stream: backgroundStream,
      builder: (context, data) {
        bool hasImage = data.data != null;
        DateTime nowTime = DateTime.now();
        return GestureDetector(
          child: Container(
            color: hasImage ? Colors.transparent : Colors.black38,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Baseline(
                  baseline: DP.toDouble(28),
                  baselineType: TextBaseline.alphabetic,
                  child: new Text(
                    "${nowTime.difference(info.date).inDays.abs()}",
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                      fontSize: 100.0,
                      color: Colors.white,
                      textBaseline: TextBaseline.alphabetic,
                    )),
                  ),
                ),
                new Baseline(
                  baseline: 0.0,
                  baselineType: TextBaseline.alphabetic,
                  child: new Text(
                    '天',
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      textBaseline: TextBaseline.alphabetic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
              if (image != null) {
                info.backgroundType = BackgroundType.IMAGE;
                info.backgroundImage = image;
                backgroundStream.add(info);
              }
            });
          },
        );
      },
    ));
  }

  Widget getTouchTips(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        width: double.infinity,
        height: DP.toDouble(80),
        color: Colors.black12,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: DP.toDouble(8),
              ),
              IconButton(
                icon: Icon(Icons.add_circle),
                color: Colors.white,
                onPressed: () {
                  showBottomSheet(
                      context: _context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            TextView(
                              "拍照",
                              textSize: 24,
                            )
                                .aligment(Alignment.center)
                                .size(height: 64, width: View.MATCH)
                                .click(() {
                              Navigator.of(context).pop();
                              ImagePicker.pickImage(source: ImageSource.camera)
                                  .then((file) {
                                if (file != null) {
                                  info.backgroundType = BackgroundType.IMAGE;
                                  info.backgroundImage = file;
                                  backgroundStream.add(info);
                                }
                              });
                            }),
                            Divider(),
                            TextView(
                              "相册",
                              textSize: 24,
                            ).size(height: 64, width: View.MATCH).click(() {
                              Navigator.of(context).pop();
                              ImagePicker.pickImage(source: ImageSource.gallery)
                                  .then((file) {
                                if (file != null) {
                                  info.backgroundType = BackgroundType.IMAGE;
                                  info.backgroundImage = file;
                                  backgroundStream.add(info);
                                }
                              });
                            }),
                            Divider(),
                            TextView(
                              "取消",
                              textSize: 24,
                            ).size(height: 64, width: View.MATCH).click(() {
                              Navigator.of(context).pop();
                            })
                          ],
                        );
                      });
                },
              ),
              getColorBox("#222831"),
              getColorBox("#29a19c"),
              getColorBox("#00adb5"),
              getColorBox("#f08a5d"),
              getColorBox("#f38181"),
              getColorBox("#a8d8ea"),
              getColorBox("#ffcfdf"),
            ],
          ),
        ),
      ),
    );
  }

  Widget getColorBox(String color) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(DP.toDouble(8)),
        color: HexColor(color),
        width: DP.toDouble(58),
        height: DP.toDouble(58),
      ),
      onTap: () {
        info.backgroundType = BackgroundType.COLOR;
        info.colorStr = color;
        backgroundStream.add(info);
      },
    );
  }
}

List<Widget> getFlagContentWidgets(BuildFlagInfo info,
    {PublishSubject<BuildFlagInfo> backgroundStream}) {
  DateTime nowTime = DateTime.now();
  String title = "距离${info.flagName}"
      "${DateTime.now().isAfter(info.date) ? "已经" : "还有"}";
  Widget background;
  if (backgroundStream != null) {
    background = Positioned(
      child: StreamBuilder<BuildFlagInfo>(
        initialData: info,
        stream: backgroundStream,
        builder: (context, data) {
          if (data.data == null) {
            return Container(
              color: Colors.black38,
            );
          }
          if (data.data.backgroundType == BackgroundType.IMAGE &&
              data.data.backgroundImage != null) {
            return SizedBox(
              child: Image.file(
                data.data.backgroundImage,
                fit: BoxFit.fitHeight,
              ),
              width: double.infinity,
              height: double.infinity,
            );
          } else {
            return Container(
              color: HexColor(data.data.colorStr) ?? Colors.black12,
              width: double.infinity,
              height: double.infinity,
            );
          }
        },
      ),
    );
  } else {
    background = Positioned(
        child: info.backgroundImage == null
            ? Container(
                color: HexColor(info.colorStr ?? "#80000000"),
                width: double.infinity,
                height: double.infinity,
              )
            : SizedBox(
                child: Image.file(
                  info.backgroundImage,
                  fit: BoxFit.fitHeight,
                ),
                width: double.infinity,
                height: double.infinity,
              ));
  }
  return [
    background,
    Positioned(
        child: Container(
      color: info.backgroundImage != null ? Colors.transparent : Colors.black38,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Baseline(
            baseline: DP.toDouble(28),
            baselineType: TextBaseline.alphabetic,
            child: new Text(
              "${nowTime.difference(info.date).inDays.abs()}",
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                fontSize: 100.0,
                color: Colors.white,
                textBaseline: TextBaseline.alphabetic,
              )),
            ),
          ),
          new Baseline(
            baseline: 0.0,
            baselineType: TextBaseline.alphabetic,
            child: new Text(
              '天',
              style: new TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                textBaseline: TextBaseline.alphabetic,
              ),
            ),
          ),
        ],
      ),
    )),
    Positioned(
        left: 0,
        right: 0,
        top: DP.toDouble(240),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            title,
            style: new TextStyle(
              fontSize: 30.0,
              color: Colors.white,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
        )),
    Positioned(
        left: 0,
        right: 0,
        bottom: DP.toDouble(240),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.date_range,
              color: Colors.white,
            ),
            SizedBox(
              width: DP.toDouble(8),
            ),
            Text(
              "${info.date.year}年${info.date.month}月${info.date.day}日${info.date.hour}时${info.date.minute}分",
              style: new TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                textBaseline: TextBaseline.alphabetic,
              ),
            )
          ],
        ))
  ];
}
