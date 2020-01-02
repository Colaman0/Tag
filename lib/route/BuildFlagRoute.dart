import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

class BuildFlagRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            TextView(
              "预览",
              textColor: Colors.white,
              textSize: 20,
            ).padding(left: 16, right: 16).size(height: View.MATCH).click(() {})
          ],
          title: Text("新建Flag"),
          backgroundColor: HexColor(Constants.MAIN_COLOR),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ListTile(
                title: TextView(
                  "背景图",
                  textSize: 24,
                ),
                leading: Icon(Icons.image),
              ),
              selectBg(),
              Divider(),
              ListTile(
                title: TextView(
                  "里程碑标题",
                  textSize: 24,
                ),
                leading: Icon(Icons.flag),
              ),
              getFlagTitleInput(),
              Divider(),
              ListTile(
                title: TextView(
                  "里程碑内容",
                  textSize: 24,
                ),
                leading: Icon(Icons.flag),
              ),
              getFlagContentInput(),
              Divider(),
            ],
          ),
        ),
      ),
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
                            child: View(child: Icon(Icons.clear, size: 16, color: Colors.white))
                                .padding(both: 8)
                                .corner(both: 5)
                                .backgroundColor(Colors.white30)
                                .click(() {
                              subject.add(null);
                            }),
                          ),
                        ],
                      ))
            .corner(both: 5)
            .margin(both: 8)
            .size(width: View.MATCH, height: 256)
            .backgroundColor(Colors.black45)
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

  Widget getFlagTitleInput() {
    return View(
      child: TextField(
        maxLength: 20,
        buildCounter: null,
        autofocus: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: "",
          hintText: "请输入Flag标题",
        ),
      ),
    ).margin(left: 16, right: 16).padding(both: 8).corner(both: 5).storke(color: Constants.MAIN_COLOR, width: 1);
  }

  Widget getFlagContentInput() {
    return View(
      child: TextField(
        maxLength: 20,
        buildCounter: null,
        autofocus: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: "",
          hintText: "请输入Flag内容",
        ),
      ),
    ).margin(left: 16, right: 16).padding(both: 8).corner(both: 5).storke(color: Constants.MAIN_COLOR, width: 1);
  }
}
