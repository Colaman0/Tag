import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class StreamPageView extends StatefulWidget {
  final PageView _pageView;
  Subject _stream;

  StreamPageView(this._pageView, {Subject stream}) {
    _stream = stream;
  }

  @override
  _StreamPageViewState createState() => _StreamPageViewState(_pageView, _stream);
}

class _StreamPageViewState extends State<StreamPageView> {
  final PageView _pageView;
  final Subject _stream;
  int _currentPage = 0;

  _StreamPageViewState(this._pageView, this._stream) {
    /// 监听流
    _stream.listen((page) {
      if (page == _currentPage) {
        return;
      }
      _currentPage = page;
      _pageView.controller?.animateToPage(page, duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _pageView;
  }
}
