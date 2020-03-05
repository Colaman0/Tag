import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tag/util/util.dart';

class View extends StatelessWidget {
  static const int MATCH = -1;
  static const int WRAP = -2;
  EdgeInsets _defalut = CustomMP().getParams();
  CustomMP _padding, _margin;
  Color _color, _storkeColor;
  int _width = View.WRAP;
  int _height = View.WRAP;
  double _storkeWidth;
  BoxDecoration _boxDecoration;
  int _bothRadius, _leftTop, _leftBottom, _rightTop, _rightBottom;
  bool _circleShpae = false;
  Function _onTap, onDoubleTap;
  bool _touchAnimation = true;
  Widget child;
  Alignment childAlignment = Alignment.center;

  View({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EdgeInsets temp = _margin?.getParams() ?? _defalut;
    _margin = CustomMP();
    return Material(
      type: _circleShpae ? MaterialType.circle : MaterialType.transparency,
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      child: Container(
        margin: temp,
        child: Ink(
          decoration: getBoxDecoration(),
          child: InkWell(
            onTap: _onTap,
            onDoubleTap: onDoubleTap,
            child: buildChild(),
          ),
        ),
      ),
    );
  }

  Widget getInkWellBackgroud(Widget child) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: _margin?.getParams() ?? _defalut,
        child: Ink(
          decoration: getBoxDecoration(),
          child: InkWell(
            child: child,
            onTap: _onTap,
            onDoubleTap: onDoubleTap,
          ),
        ),
      ),
    );
  }

  Widget buildChild() {
    Widget body;
    if (_width == View.MATCH && _height == View.MATCH) {
      body = Container(
        padding: _padding?.getParams() ?? _defalut,
        margin: _margin?.getParams() ?? _defalut,
        alignment: childAlignment,
        constraints: BoxConstraints.expand(),
        child: initChild(),
      );
    } else if (_width == View.WRAP && _height == View.WRAP) {
      body = Container(
        alignment: childAlignment,
        padding: _padding?.getParams() ?? _defalut,
        margin: _margin?.getParams() ?? _defalut,
        child: initChild(),
      );
    } else if (_width == View.MATCH && _height == View.WRAP) {
      body = Container(
        alignment: childAlignment,
        padding: _padding?.getParams() ?? _defalut,
        margin: _margin?.getParams() ?? _defalut,
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[initChild()],
        ),
      );
    } else if (_width == View.WRAP && _height == View.MATCH) {
      body = Container(
        alignment: childAlignment,
        padding: _padding?.getParams() ?? _defalut,
        margin: _margin?.getParams() ?? _defalut,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[initChild()],
        ),
      );
    } else {
      body = buildDpChild();
    }
    return body;
  }

  Widget buildDpChild() {
    Widget body;
    if (isDpValue(_width) && isDpValue(_height)) {
      body = Container(
          alignment: childAlignment,
          padding: _padding?.getParams() ?? _defalut,
          margin: _margin?.getParams() ?? _defalut,
          width: DP.toDouble(_width),
          height: DP.toDouble(_height),
          child: initChild());
    } else if (!isDpValue(_width) && isDpValue(_height)) {
      if (_width == View.MATCH) {
        body = Container(
            alignment: childAlignment,
            padding: _padding?.getParams() ?? _defalut,
            margin: _margin?.getParams() ?? _defalut,
            width: double.infinity,
            height: DP.toDouble(_height),
            child: initChild());
      } else {
        body = Container(
          alignment: childAlignment,
          padding: _padding?.getParams() ?? _defalut,
          margin: _margin?.getParams() ?? _defalut,
          height: DP.toDouble(_height),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[initChild()],
          ),
        );
      }
    } else if (isDpValue(_width) && !isDpValue(_height)) {
      if (_height == View.MATCH) {
        body = Container(
          padding: _padding?.getParams() ?? _defalut,
          margin: _margin?.getParams() ?? _defalut,
          alignment: childAlignment,
          height: double.infinity,
          width: DP.toDouble(_width),
          child: initChild(),
        );
      } else {
        body = Container(
          padding: _padding?.getParams() ?? _defalut,
          margin: _margin?.getParams() ?? _defalut,
          alignment: childAlignment,
          width: DP.toDouble(_width),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[initChild()],
          ),
        );
      }
    }
    return body;
  }

  Widget initChild() {
    return child ?? Text("");
  }

  Widget expandCheck(Widget child) =>
      (child is Column || child is Row) ? Expanded(child: child) : child;

  bool isDpValue(int value) => value >= 0;

  View padding({int both, int left, int right, int top, int bottom}) {
    _padding = CustomMP(
        both: both, left: left, right: right, top: top, bottom: bottom);
    return this;
  }

  View margin({int both, int left, int right, int top, int bottom}) {
    _margin = CustomMP(
        both: both, left: left, right: right, top: top, bottom: bottom);
    return this;
  }

  View backgroundColorStr(String color) {
    _color = HexColor(color);
    return this;
  }

  View backgroundColor(Color color) {
    _color = color;
    return this;
  }

  View touchAnimation(bool anim) {
    _touchAnimation = anim;
    return this;
  }

  View size({int width = View.WRAP, int height = View.WRAP}) {
    _width = width;
    _height = height;
    return this;
  }

  View corner(
      {int both, int leftTop, int leftBottom, int rightTop, int rightBottom}) {
    _bothRadius = both;
    _leftTop = leftTop;
    _leftBottom = leftBottom;
    _rightTop = rightTop;
    _rightBottom = rightBottom;
    return this;
  }

  View aligment(Alignment alignment) {
    this.childAlignment = alignment;
    return this;
  }

  View circle() {
    _circleShpae = true;
    return this;
  }

  View storke({String color, int width}) {
    _storkeColor = HexColor(color);
    _storkeWidth = DP.toDouble(width);
    return this;
  }

  BoxDecoration getBoxDecoration() {
    if (_boxDecoration == null) {
      _boxDecoration = BoxDecoration(
          color: _color ?? Colors.transparent,
          borderRadius: getRadius(),
          shape: _circleShpae ? BoxShape.circle : BoxShape.rectangle,
          border: (_storkeWidth == 0 || _storkeColor == null)
              ? null
              : Border.all(color: _storkeColor, width: _storkeWidth));
    }
    return _boxDecoration;
  }

  BorderRadius getRadius() {
    if (_circleShpae) {
      return null;
    }
    var bothRadius = DP.toDouble(_bothRadius);
    return BorderRadius.only(
      topLeft: Radius.circular(
          _leftTop == null ? bothRadius : DP.toDouble(_leftTop)),
      topRight: Radius.circular(
          _rightTop == null ? bothRadius : DP.toDouble(_rightTop)),
      bottomLeft: Radius.circular(
          _leftBottom == null ? bothRadius : DP.toDouble(_leftBottom)),
      bottomRight: Radius.circular(
          _rightBottom == null ? bothRadius : DP.toDouble(_rightBottom)),
    );
  }

  View click(Function callback) {
    _onTap = callback;
    return this;
  }

  View doubleClick(Function callback) {
    onDoubleTap = callback;
    return this;
  }
}
