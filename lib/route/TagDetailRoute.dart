import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tag/base/bloc.dart';
import 'package:tag/bloc/BuildTagBloc.dart';
import 'package:tag/entity/BuildTagInfo.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/NaigatorUtils.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/tag/TodoItemWidget.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

/// Tag详情页面

class TagDetailRoute extends StatefulWidget {
  @override
  _TagDetailRouteState createState() => _TagDetailRouteState();
}

class _TagDetailRouteState extends State<TagDetailRoute> {
  BuildTagInfo _initInfo;

  List<TodoItemWidget> _todoItems = List();

  VoidCallback _voidCallback;

  PublishSubject<String> progressStream = PublishSubject();
  PublishSubject<List<Todo>> todoStream = PublishSubject();
  BuildTagBloc _bloc = BuildTagBloc();

  @override
  Widget build(BuildContext context) {
    init(context);
    return BlocProvider(
      bloc: _bloc,
      child: Scaffold(
        backgroundColor: HexColor(Constants.MAIN_COLOR),
        appBar: AppBar(
          elevation: 0.0,
          title: TextView(
            "详情",
            textSize: 28,
            textColor: Colors.white,
          ),
          backgroundColor: HexColor(Constants.MAIN_COLOR),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.brightness_medium),
              onPressed: () {
                NavigatorUtils.getInstance()
                    .toBuildTag(context, buildTagInfo: getTagInfo())
                    .then((data) {
                  if (data != null && data is BuildTagInfo) {
                    setState(() {
                      _initInfo = data;
                    });
                  }
                });
              },
            )
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            View(
                    child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.bookmark,
                      color: Colors.white,
                    ),
                    TextView(
                      "${_initInfo.tagName}",
                      textColor: Colors.white,
                      textSize: 32,
                    ).margin(left: 16)
                  ],
                ),
                SizedBox(
                  height: DP.toDouble(16),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    TextView(
                      "${_initInfo.getDate().year}-${_initInfo.getDate().month}-${_initInfo.getDate().day.toString().padLeft(2, '0')}   ${_initInfo.getDate().hour.toString().padLeft(2, '0')}:${_initInfo.getDate().minute.toString().padLeft(2, '0')}",
                      textColor: Colors.white,
                      textSize: 28,
                    ).margin(left: 16)
                  ],
                ),
                SizedBox(
                  height: DP.toDouble(16),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.assignment_turned_in,
                      color: Colors.white,
                    ),
                    StreamBuilder(
                      initialData: createProgressText(
                          _initInfo.todo
                              .where((item) => item.isTodoFinish())
                              .toList()
                              .length,
                          _initInfo.todo.length),
                      stream: progressStream,
                      builder: (context, data) {
                        return TextView(
                          data?.data ?? "",
                          textColor: Colors.white,
                          textSize: 28,
                        ).margin(left: 16);
                      },
                    )
                  ],
                )
              ],
            ))
                .aligment(Alignment.topLeft)
                .padding(left: 16, top: 16, right: 16, bottom: 48)
                .size(width: View.MATCH)
                .backgroundColorStr(Constants.MAIN_COLOR),
            Expanded(
              child: View(child: buildTodoWidget(context))
                  .size(width: View.MATCH, height: View.MATCH)
                  .padding(top: 16, bottom: 16)
                  .corner(leftTop: 30, rightTop: 30)
                  .backgroundColor(Colors.white),
            )
          ],
        ),
      ),
    );
  }

  /// 初始化数据
  void init(BuildContext context) {
    if (_initInfo == null) {
      _initInfo = NavigatorUtils.getPreArguments(context)[Constants.DATA];
      _bloc.initData(_initInfo);
      _voidCallback = () {
        /// 已完成的todo数量
        int finish = 0;
        _todoItems.forEach((item) {
          if (item.getTodoEntity().isTodoFinish()) {
            finish++;
          }
        });
        progressStream.add(createProgressText(finish, _todoItems.length));
      };
    }
  }

  String createProgressText(int finish, int total) => "清单进度 : $finish / $total";

  Widget buildTodoWidget(BuildContext context) {
    List<Todo> datas = _initInfo.todo;
    _todoItems.clear();
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(
              height: DP.toDouble(1),
            ),
        itemCount: datas.length ?? 0,
        itemBuilder: (context, index) {
          TodoItemWidget widget = TodoItemWidget(
            todoEntity: datas[index],
            voidCallback: _voidCallback,
          );
          _todoItems.add(widget);
          if (_todoItems.length == datas.length) {
            _voidCallback();
          }
          return widget;
        });
  }

  BuildTagInfo getTagInfo() {
    _initInfo.todo = _todoItems.map((item) => item.getTodoEntity()).toList();
    return _initInfo;
  }
}
