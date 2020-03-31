import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tag/entity/BuildFlagInfo.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/flag/FlagListWidget.dart';
import 'package:tag/view/widget/view/View.dart';

class TimeTagRoute extends StatefulWidget {
  @override
  _TimeTagRouteState createState() => _TimeTagRouteState();
}

class _TimeTagRouteState extends State<TimeTagRoute> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BuildFlagInfo>>(
      builder: (context, data) {
        return FlagListWidget(infos: data.data);
      },
    );
  }
}
