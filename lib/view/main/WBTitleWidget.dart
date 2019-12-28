import 'package:flutter/material.dart';
import 'package:tag/view/widget/BaseWidget.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

class WBTitle extends StatefulWidget {
  final WBTitleOption option;

  WBTitle(this.option, {Key key}) : super(key: key);

  @override
  _WBTitleState createState() => _WBTitleState(this.option);
}

class _WBTitleState extends State<WBTitle> {
  final WBTitleOption option;

  _WBTitleState(this.option);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        View(
          child: ClipOval(
              child: Image.network(
            option.avatar,
            fit: BoxFit.cover,
          )),
        ).size(width: 72, height: 72),
        View(
          child: Column(
            children: <Widget>[
              TextView(option.name, textSize: 22, textColor: Colors.black),
              TextView(option.secondTitle, textColor: Colors.grey)
            ],
          ),
        ).margin(left: 16),
        Spacer(),
      ],
    );
  }
}

class WBTitleOption {
  final String avatar;
  final String name;
  final String secondTitle;

  WBTitleOption({this.avatar, this.name, this.secondTitle});
}
