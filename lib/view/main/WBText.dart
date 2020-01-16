import 'package:flutter/material.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/BaseWidget.dart';
import 'package:tag/view/widget/view/View.dart';
import 'package:rxdart/rxdart.dart';

class WBText extends StatefulWidget {
  final String content;

  const WBText({Key key, this.content}) : super(key: key);

  @override
  _WBTextState createState() => _WBTextState(content);
}

class _WBTextState extends State<WBText> {
  final String content;
  final PublishSubject<bool> expandStream = PublishSubject();
  bool expand = false;

  _WBTextState(this.content);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, box) {
        if (IsExpansion(content, box, SP.get(20), 3)) {
          return AnimatedContainer(
              duration: Duration(seconds: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  expand
                      ? Text(content,
                          softWrap: true,
                          style: TextStyle(
                              color: Colors.black, fontSize: SP.get(20)))
                      : Text(content,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black, fontSize: SP.get(20))),
                  View(
                    child: Icon(expand
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down),
                  ).size(width: 48, height: 48).click(() {
                    setState(() {
                      expand = !expand;
                    });
                  })
                ],
              ));
        } else {
          return Container(
            child: Text(
              content,
              style: TextStyle(color: Colors.black, fontSize: SP.get(20)),
            ),
          );
        }
      },
    );
  }
}
