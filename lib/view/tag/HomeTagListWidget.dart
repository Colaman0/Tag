import 'package:flutter/cupertino.dart';
import 'package:tag/entity/BuildFlagInfo.dart';
import 'package:tag/view/flag/FlagListWidget.dart';

/// 首页tag列表的widget
class HomeTagListWidget extends StatefulWidget {
  @override
  _HomeTagListWidgetState createState() => _HomeTagListWidgetState();
}

class _HomeTagListWidgetState extends State<HomeTagListWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BuildFlagInfo>>(
      initialData: [
        BuildFlagInfo(
            flagName: "距离林世杰生日",
            date: DateTime.now(),
            categories: ["生日", "自己"]),
        BuildFlagInfo(
            flagName: "距离林XX生日", date: DateTime.now(), categories: ["恩啊"])
      ],
      builder: (context, data) {
        List<BuildFlagInfo> infos = data.data;
        return FlagListWidget(infos: infos);
      },
    );
  }
}
