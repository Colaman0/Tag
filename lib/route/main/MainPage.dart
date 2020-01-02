import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/NaigatorUtils.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/bind/BindViewPager.dart';
import 'package:tag/view/main/MainContentsWidget.dart';
import 'package:tag/view/widget/CustomDialog.dart';
import 'package:tag/view/widget/view/View.dart';

import '../TimeTagHome.dart';

/// 首页homepage
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _controller = new PageController();
  final PublishSubject<int> _pageStream = new PublishSubject();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: StreamPageView(
        PageView(
          physics: ScrollPhysics(),
          controller: _controller,
          scrollDirection: Axis.horizontal,
          onPageChanged: (page) => _pageStream.add(page),
          children: <Widget>[
            TimeTagRoute(),
            View().size(width: 200, height: 200).backgroundColor(Colors.cyan),
          ],
        ),
        stream: _pageStream,
      )),
      bottomNavigationBar: StreamBuilder<int>(
        stream: _pageStream,
        initialData: 0,
        builder: (context, snap) {
          return BottomAppBar(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                IconButton(
                  padding: EdgeInsets.all(DP.get(16)),
                  icon: Icon(
                    Icons.home,
                    color: snap.data == 0
                        ? HexColor(Constants.MAIN_COLOR)
                        : HexColor(Constants.COLOR_3),
                  ),
                  onPressed: () => _pageStream.add(0),
                ),
                IconButton(
                  icon: Icon(
                    Icons.business,
                    color: snap.data == 1
                        ? HexColor(Constants.MAIN_COLOR)
                        : HexColor(Constants.COLOR_3),
                  ),
                  onPressed: () => _pageStream.add(1),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
            shape: CircularNotchedRectangle(),
          );
        },
      ),
      // 设置 floatingActionButton 在底部导航栏中间
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor(Constants.MAIN_COLOR),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  children: <Widget>[
                    ListTile(
                      title: Text("新建里程碑"),
                      leading: Icon(Icons.flag),
                      subtitle: Text("记录值得纪念的时刻"),
                      onTap: () {
                        NavigatorUtils.getInstance().toBuildFlag(context);
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Text("新建Tag"),
                      leading: Icon(Icons.timelapse),
                      subtitle: Text("标记未来需要完成的Tag"),
                      onTap: () {},
                    )
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
