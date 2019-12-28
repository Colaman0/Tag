import 'package:flutter/material.dart';
import 'package:tag/view/main/WBText.dart';
import 'package:tag/view/widget/BaseWidget.dart';
import 'package:tag/view/widget/PreviewPhotoView.dart';
import 'package:tag/view/widget/RefreshLoadMoreListView.dart';
import 'package:tag/view/widget/view/View.dart';

import 'WBTitleWidget.dart';

class MainContentsWidget extends StatefulWidget {
  @override
  _MainContentsWidgetState createState() => _MainContentsWidgetState();
}

class _MainContentsWidgetState extends State<MainContentsWidget> with AutomaticKeepAliveClientMixin {
  WBDataFactory _wbDataFactory;

  @override
  void initState() {
    super.initState();
    _wbDataFactory = WBDataFactory();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); //必须添加
    return RefreshLoadmoreListView(_wbDataFactory, RefreshLoadmoreOption());
  }

  refresh() async {
    return Future.value(true);
  }

  Widget getWBItemWidget(BuildContext context, int index) {}

  @override
  bool get wantKeepAlive => true;
}

class WBDataFactory extends RLDataFactory {
  String TEST_CONTENT =
      "dadfasfadadfasfadadfasfadadfasfadadfasfadadfasfadadfasfadadfasfadadfasfadadfasfadadfasfadadfasfa"
      "dadfasfadadfasfadadfasfadadfasfadadfasfadadfasfadadfasfadadfasfadadfasfadadfasfadadfasfadadfasfa";

  @override
  Future<PageDTO> createFuture(int page) {
    return Future.delayed(Duration(seconds: 3), () => TestDTO());
  }

  @override
  Widget createItemWidget(BuildContext context, int index, data) {
    return View(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          WBTitle(WBTitleOption(
              avatar: "https://wx3.sinaimg.cn/mw690/4c033d1egy1g9lzuvqnzsj22c02c0u0z.jpg",
              name: "张三",
              secondTitle: "time")),
          View(
            child: WBText(content: TEST_CONTENT),
          ).margin(top: 16, bottom: 16),
          PreviewPhotosView(
            pics: const [
              "https://wx3.sinaimg.cn/mw690/98f0f55fly1g9o3xdj8kxj20u011e7bi.jpg",
            ],
            heroTag: index.toString(),
          ),
        ],
      ),
    ).size(width: View.MATCH, height: View.WRAP).padding(both: 24);
  }
}

class TestDTO extends PageDTO {
  @override
  List getDatas() {
    return const ["1"];
  }

  @override
  bool isLastPage() {
    return false;
  }
}
