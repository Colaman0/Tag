import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/route/BuildTagRoute.dart';
import 'package:tag/util/NaigatorUtils.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/bind/BindViewPager.dart';
import 'package:tag/view/main/MainContentsWidget.dart';
import 'package:tag/view/widget/CustomDialog.dart';
import 'package:tag/view/widget/view/TextView.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: HexColor(Constants.MAIN_COLOR)),
        title: StreamBuilder<int>(
          stream: _pageStream,
          builder: (context, page) => TextView(
            page.data == 0 ? 'Tag' : '里程碑',
            textSize: 30,
          ).aligment(Alignment.centerLeft),
        ),
      ),
      drawer: getDrawer(),
      backgroundColor: Colors.white,
      body: Container(
          child: StreamPageView(
        PageView(
          physics: NeverScrollableScrollPhysics(),
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
                  padding: EdgeInsets.all(DP.toDouble(16)),
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
                      title: Text("Flag"),
                      leading: Icon(Icons.flag),
                      subtitle: Text("记录值得纪念的时刻"),
                      onTap: () {
                        Navigator.of(context).pop();
                        NavigatorUtils.getInstance().toBuildFlag(context);
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Text("Tag"),
                      leading: Icon(Icons.timelapse),
                      subtitle: Text("标记未来需要完成的Tag"),
                      onTap: () {
                        Navigator.of(context).pop();
                        NavigatorUtils.getInstance().toBuildTag(context);
                      },
                    )
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getDrawer() {
    return Container(
      color: Colors.white,
      width: DP.toDouble(300),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
              height: 220,
              alignment: Alignment.center,
              color: HexColor(Constants.MAIN_COLOR),
              child: TextView(
                "K",
                textSize: 60,
                textColor: HexColor(Constants.MAIN_COLOR),
              )
                  .size(width: 160, height: 160)
                  .circle()
                  .padding(both: 26)
                  .backgroundColor(Colors.white)),
          Divider(height: 1),
          getIconTextRow(icon: Icons.person, title: '个人信息', onPress: () {}),
          Divider(height: 1),
          getIconTextRow(icon: Icons.settings, title: '设置', onPress: () {}),
          Divider(height: 1),
          getIconTextRow(icon: Icons.data_usage, title: '导入数据', onPress: () {}),
          Divider(height: 1),
          getIconTextRow(icon: Icons.cloud, title: '同步云端', onPress: () {}),
          Divider(height: 1),
          getIconTextRow(icon: Icons.book, title: '说明', onPress: () {}),
          Divider(height: 1),
          getIconTextRow(icon: Icons.update, title: '版本更新', onPress: () {}),
          Divider(height: 1),
        ],
      ),
    );
  }

  Widget getIconTextRow({IconData icon, String title, Function onPress}) {
    return View(
      child: Row(
        children: <Widget>[
          Icon(icon),
          TextView(
            title,
            textSize: 26,
          ).aligment(Alignment.centerLeft).padding(left: 32)
        ],
      ),
    )
        .padding(both: 24)
        .click(onPress)
        .size(width: View.MATCH, height: View.WRAP)
        .aligment(Alignment.centerLeft);
  }
}
