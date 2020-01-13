import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/utils/solar_term_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tag/base/bloc.dart';
import 'package:tag/bloc/BuildFlagBloc.dart';
import 'package:tag/bloc/BuildTagBloc.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/imp/basePage.dart';
import 'package:tag/route/BuildTagRoute.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

import '../BaseBuildPage.dart';

class SelectFlagBg extends StatelessWidget with BasePage {
  BuildTagBloc _bloc;

  File _file;

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of(context);
    _bloc.getSelectDate();
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
                            child: Image.file(data.data, fit: BoxFit.fitHeight),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: View(
                                    child: Icon(Icons.clear,
                                        size: 16, color: Colors.white))
                                .padding(both: 8)
                                .corner(both: 5)
                                .backgroundColor(Colors.black38)
                                .click(() {
                              subject.add(null);
                            }),
                          ),
                          getDays()
                        ],
                      ))
            .corner(both: 5)
            .margin(both: 24)
            .size(width: View.MATCH, height: 256)
            .backgroundColor(Colors.black38)
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

  Widget getDays() {
    return Positioned(
      child: StreamBuilder(
        initialData: DateTime.now(),
        stream: _bloc.getSelectDateStream(),
        builder: (context, data) {
          return TextView(
            DateTime.now().difference(DateTime.now()).inDays.toString(),
            textSize: 40,
            textColor: Colors.white,
          );
        },
      ),
    );
  }

  @override
  bool dataVaild() => true;

  @override
  String dataTips() {
    // TODO: implement dataTips
    return "";
  }

  @override
  void saveData() {
    // TODO: implement saveData
  }
}
