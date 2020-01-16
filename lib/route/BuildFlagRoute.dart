import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/imp/basePage.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/flag/EditContent.dart';
import 'package:tag/view/flag/EditContentWidget.dart';
import 'package:tag/view/flag/SelectFlagBg.dart';
import 'package:tag/view/widget/BuildLineWidget.dart';
import 'package:tag/view/widget/CalendarWidget.dart';
import 'package:tag/view/widget/StatusBar.dart';
import 'package:tag/view/widget/Toast.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

class BuildFlagRoute extends StatelessWidget {
  PublishSubject pageStream = PublishSubject<int>();
  List<BasePage> basePages = List();

  Widget buildProgressWidget;
  PageController _controller = PageController();

  List<Widget> pages = List();

  BuildFlagRoute({Key key}) : super(key: key) {
    buildProgressWidget = BuildLineWidget(<Widget>[
      TextView("日期", textSize: 20),
      TextView("背景图", textSize: 20),
      TextView("里程碑", textSize: 20)
    ], pageStream);
  }

  @override
  Widget build(BuildContext context) {
    pages.add(CalendarWidget());
    pages.add(EditFlagContentWidget());
    pages.add(EditContent());

    return  Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              TextView(
                "预览",
                textColor: Colors.white,
                textSize: 20,
              )
                  .padding(left: 16, right: 16)
                  .size(height: View.MATCH)
                  .click(() {})
            ],
            centerTitle: true,
            title: Text("新建Flag"),
            backgroundColor: HexColor(Constants.MAIN_COLOR),
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                buildProgressWidget,
                Expanded(
                    child: PageView(
                      controller: _controller,
                      onPageChanged: (int page) {
                        pageStream.add(page);
                      },
                      physics: NeverScrollableScrollPhysics(),
                      children: pages,
                    )),
                bottomActionWidget()
              ],
            ),
      ),
    );
  }

  Widget bottomActionWidget() {
    return StreamBuilder(
      initialData: 0,
      stream: pageStream,
      builder: (context, data) {
        int page = data.data;
        return Container(
          margin: EdgeInsets.only(bottom: DP.get(32)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              OutlineButton(
                textColor: Colors.black,
                disabledTextColor: Colors.grey,
                child: Text("上一步"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                onPressed: page == 0
                    ? null
                    : () {
                  _controller.animateToPage(--page,
                      duration: Duration(milliseconds: 100),
                      curve: Curves.bounceIn);
                },
              ),
              MaterialButton(
                animationDuration: Duration(microseconds: 300),
                color: HexColor(Constants.COLOR_BLUE),
                textColor: Colors.white,
                disabledTextColor: Colors.white,
                disabledColor: HexColor(Constants.COLOR_3),
                child: Text("下一步"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                onPressed: page == pages.length - 1
                    ? null
                    : () {
                  BasePage basePage = (pages[page] as BasePage);
                  if (basePage.dataVaild()) {
                    _controller.animateToPage(++page,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.bounceIn);
                  } else {
                    Toast.toast(context, msg: basePage.dataTips());
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  Widget selectBg() {
    PublishSubject<File> subject = PublishSubject();
    return StreamBuilder(
      stream: subject,
      builder: (context, data) {
        return View(
            child: data.data == null
                ? Icon(
              Icons.add,
              size: DP.get(64),
              color: HexColor(Constants.MAIN_COLOR),
            )
                : Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: <Widget>[
                Positioned(
                  child: Image.file(data.data),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: View(
                      child: Icon(Icons.clear,
                          size: 16, color: Colors.white))
                      .padding(both: 8)
                      .corner(both: 5)
                      .backgroundColor(Colors.white70)
                      .click(() {
                    subject.add(null);
                  }),
                ),
              ],
            ))
            .corner(both: 5)
            .margin(both: 24)
            .size(width: View.MATCH, height: 256)
            .backgroundColorStr(Constants.COLOR_3)
            .click(() {
          ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
            if (image != null) {
              subject.add(image);
            }
          });
        });
      },
    );
  }
}
