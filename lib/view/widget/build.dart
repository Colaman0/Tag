import 'package:flutter/material.dart';
import 'package:tag/view/widget/view/View.dart';

class BuildTagWidget extends StatefulWidget {
  _BuildTagWidgetState buildTagWidgetState = _BuildTagWidgetState();

  @override
  _BuildTagWidgetState createState() => buildTagWidgetState;


}

class _BuildTagWidgetState extends State<BuildTagWidget> {
  OverlayEntry _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return View(
      child: Text("123"),
    ).backgroundColor(Colors.white).size(width: 50, height: 50);
  }

  void show() {
    Overlay.of(context).insert(this._overlayEntry);
  }

  void dismiss() {
    this._overlayEntry.remove();
  }
}
    