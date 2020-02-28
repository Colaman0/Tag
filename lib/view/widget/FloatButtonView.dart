import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/util.dart';

class FloatButtonView extends StatelessWidget {
  PublishSubject<bool> _visibleStream = PublishSubject();
  bool _isExpand = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: _visibleStream,
      builder: (context, snap) {
        _isExpand = snap.data;
        double size = _isExpand ? DP.toDouble(64) : 0;
        return  Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                      AnimatedContainer(
                              margin: EdgeInsets.all(4),
                              color: Colors.transparent,
                              duration: Duration(microseconds: 300),
                              child: SizedBox(
                                  width: size,
                                  height: size,
                                  child: Icon(Icons.add),
                              )),
                      AnimatedContainer(
                              margin: EdgeInsets.all(4),
                              color: Colors.transparent,
                              duration: Duration(microseconds: 300),
                              child: SizedBox(
                                  width: size,
                                  height: size,
                                  child: Icon(Icons.add),
                              )),
                      AnimatedContainer(
                              margin: EdgeInsets.all(4),
                              color: Colors.transparent,
                              duration: Duration(microseconds: 300),
                              child: FloatingActionButton(
                                  backgroundColor: HexColor(Constants.MAIN_COLOR),
                                  onPressed: () {
                                      _visibleStream.add(!_isExpand);
                                  },
                                  child: Icon(Icons.add),
                              )),
                  ],
        );
      },
    );
  }
}
