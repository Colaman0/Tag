import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/imp/basePage.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/View.dart';

import '../BaseBuildPage.dart';

class SelectFlagBg extends StatelessWidget with BasePage {
  File _file;

  @override
  Widget build(BuildContext context) {
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
            _file = image;
            if (image != null) {
              subject.add(image);
            }
          });
        });
      },
    );
  }

  @override
  bool dataVaild() => true;

  @override
  String dataTips() {
    // TODO: implement dataTips
    return "";
  }
}
