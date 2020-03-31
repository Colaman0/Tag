import 'package:flutter/cupertino.dart';
import 'package:tag/entity/BuildTagInfo.dart';
import 'package:tag/util/DataProvider.dart';

import 'package:tag/view/tag/TagListWidget.dart';

/// 首页tag列表的widget
class HomeTagListWidget extends StatefulWidget {
  @override
  _HomeTagListWidgetState createState() => _HomeTagListWidgetState();
}

class _HomeTagListWidgetState extends State<HomeTagListWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BuildTagInfo>>(
      initialData: DataProvider.getInstance().tags,
      stream: DataProvider.getInstance().getTagDataStream(),
      builder: (context, data) {
        List<BuildTagInfo> infos = data.data;
        print(infos);
        return TagListWidget(infos: infos);
      },
    );
  }
}
