import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tag/base/bloc.dart';
import 'package:tag/bloc/BuildTagBloc.dart';
import 'package:tag/entity/BuildTagInfo.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/entity/TodoEntity.dart';
import 'package:tag/util/NaigatorUtils.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/tag/SearchCategoryRoute.dart';
import 'package:tag/view/widget/CalendarWidget.dart';
import 'package:tag/view/widget/CategroyItemWidget.dart';
import 'package:tag/view/widget/TimeSelectWidget.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

class BuildTagRoute extends StatelessWidget {
  BuildTagBloc _tagBloc = BuildTagBloc();
  BuildContext _context;

  BuildTagRoute();

  DateTime _createTime;

  TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    initData(context);

    return BlocProvider(
      bloc: _tagBloc,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Builder(
            builder: (BuildContext context) {
              _context = context;
              return Container(
                padding: EdgeInsets.only(top: ScreenUtil.statusBarHeight),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                      HexColor("#537895"),
                      HexColor("#868f96")
                    ])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        View(
                          child: Icon(Icons.arrow_back,
                              size: DP.toDouble(48), color: Colors.white),
                        ).size(width: 64, height: 64).click(() {
                          Navigator.of(context).pop();
                        }),
                        TextView(
                          _tagBloc.isInit ? "编辑 Tag" : "创建 Tag",
                          textSize: 30,
                          textColor: Colors.white,
                        ).aligment(Alignment.centerLeft).margin(left: 16),
                      ],
                    ),
                    View(
                        child: Material(
                      color: Colors.transparent,
                      child: TextField(
                        onChanged: (name) => _tagBloc.setTagName(name),
                        style: TextStyle(
                            color: Colors.white, fontSize: SP.get(28)),
                        cursorColor: Colors.white70,
                        maxLines: 1,
                        maxLength: 10,
                        autofocus: false,
                        controller: TextEditingController.fromValue(
                            TextEditingValue(text: _tagBloc.getTagName())),
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: HexColor(Constants.MAIN_COLOR))),
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: "输入标题",
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: HexColor(Constants.MAIN_COLOR)))),
                      ),
                    )).margin(left: 16, right: 16, top: 16),
                    SizedBox(
                      height: DP.toDouble(24),
                    ),
                    Expanded(
                      child: View(
                              child: Column(
                        children: <Widget>[
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  getDateItem(),
                                  getTimeItem(),
                                  getTodoListItem(),
                                ],
                              ),
                            ),
                          ),
                          getConfirmButton(context)
                        ],
                      ))
                          .padding(both: 32)
                          .size(width: View.MATCH, height: View.MATCH)
                          .corner(leftTop: 30, rightTop: 30)
                          .backgroundColor(Colors.white),
                    )
                  ],
                ),
              );
            },
          )),
    );
  }

  /// 初始化数据
  void initData(BuildContext context) {
    Map arguments = NavigatorUtils.getPreArguments(context);
    if (arguments != null && arguments[Constants.DATA] != null) {
      // 把初始数据放到bloc中
      _tagBloc.initData(arguments[Constants.DATA]);
      // 设置初始的Tag名字
      _editingController.value = TextEditingValue(text: _tagBloc.getTagName());
    }
  }

  /// 获取清单列表的UI
  Widget getTodoListItem() {
    return View(
        child: StreamBuilder<List<TodoEntity>>(
            initialData: _tagBloc.getTodoList(),
            stream: _tagBloc.getTodoListStream(),
            builder: (context, data) {
              List<Widget> childs = [
                View(
                  child: Row(
                    children: <Widget>[
                      TextView(
                        "清单",
                        textSize: 28,
                        textColor: Colors.white,
                      ),
                      Spacer(),
                      Icon(
                        Icons.format_list_bulleted,
                        color: Colors.white,
                      )
                    ],
                  ),
                ).padding(both: 8).corner(both: 8).backgroundColorStr("#537895")
              ];

              childs.add(Divider(
                color: Colors.transparent,
              ));

              /// 把对应的清单item内容转换为文字展示
              data.data.forEach((todoContent) {
                childs.add(Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    View(child: Icon(Icons.brightness_1, size: DP.toDouble(16)))
                        .margin(top: 10, right: 18),
                    Expanded(
                      child: TextView(
                        todoContent.todo ?? "",
                        textSize: 24,
                      ).aligment(Alignment.centerLeft),
                    )
                  ],
                ));
                childs.add(Divider());
              });

              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: childs,
              );
            })).margin(top: 16).padding(top: 8, bottom: 8).click(() {
      /// 跳转到编辑清单页面
      NavigatorUtils.getInstance()
          .toEditTodoList(_context, todos: _tagBloc.getTodoList())
          .then((todos) {
        // 更新清单数据
        _tagBloc.setTodoList(todos);
      });
    });
  }

  /// 获取一个展示日期的widget
  Widget getDateItem() {
    DateTime time;
    return View(
      child: Column(
        children: <Widget>[
          TextView(
            "日期",
            textSize: 24,
            textColor: Colors.grey,
          ).aligment(Alignment.centerLeft),
          StreamBuilder<DateTime>(
              initialData: _tagBloc.getSelectDate(),
              stream: _tagBloc.getSelectDateStream(),
              builder: (context, data) {
                time = data.data;
                String dateStr = "${time.year} 年 ${time.month} 月 ${time.day} 日";
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: TextView(
                        dateStr,
                        textSize: 28,
                      ).aligment(Alignment.centerLeft).margin(top: 12),
                    ),
                    Icon(
                      Icons.calendar_today,
                      size: DP.toDouble(24),
                      color: HexColor("#313B79"),
                    )
                  ],
                );
              }),
          Divider(
            color: HexColor("#313B79"),
          )
        ],
      ),
    ).click(() {
      /// 弹出一个底部弹窗用于选择日期
      showBottomSheet(
          context: _context,
          backgroundColor: Colors.black38,
          builder: (context) {
            DateTime time = _tagBloc.getSelectDate();
            return Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    View(
                      child: CalendarWidget(
                          time: time ?? _createTime,
                          selectCallback: (date) {
                            time = date;
                          }),
                    )
                        .backgroundColor(Colors.white)
                        .corner(rightTop: 20, leftTop: 20),
                    SizedBox(
                      width: double.infinity,
                      height: DP.toDouble(70),
                      child: RaisedButton(
                        child: TextView(
                          "确定",
                          textColor: Colors.white,
                          textSize: 24,
                        ),
                        color: HexColor("#13547a"),
                        onPressed: () {
                          _tagBloc.selectDate(time);
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ));
          });
    });
  }

  /// 获取一个关于时间的widget，点击选择时间(时&分)
  Widget getTimeItem() {
    DateTime time;
    return View(
      child: Column(
        children: <Widget>[
          TextView(
            "时间",
            textSize: 24,
            textColor: Colors.grey,
          ).aligment(Alignment.centerLeft),
          StreamBuilder<DateTime>(
              initialData: _tagBloc.getSelectDate(),
              stream: _tagBloc.getSelectDateStream(),
              builder: (context, data) {
                time = data.data;
                String dateStr = "${time.hour} 时 ${time.minute} 分 ";
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: TextView(
                        dateStr,
                        textSize: 28,
                      ).aligment(Alignment.centerLeft).margin(top: 12),
                    ),
                    Icon(
                      Icons.access_time,
                      size: DP.toDouble(24),
                      color: HexColor("#313B79"),
                    )
                  ],
                );
              }),
          Divider(
            color: HexColor("#313B79"),
          )
        ],
      ),
    ).margin(top: 32, bottom: 16).click(() {
      showBottomSheet(
          context: _context,
          backgroundColor: Colors.black38,
          builder: (context) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.bottomCenter,
              child: TimeSelectView(
                  dateTime: time,
                  selectTimeFun: (time) => _tagBloc.selectDate(time)),
            );
          });
    });
  }

  /// 获取一个确认按钮，点击后创建一个 Tag
  Widget getConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: DP.toDouble(70),
      child: RaisedButton.icon(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(DP.toDouble(12)))),
        icon: Icon(Icons.add_circle, color: Colors.white30),
        color: HexColor("#13547a"),
        label: TextView(
          _tagBloc.isInit ? '保存' : '创建',
          textColor: Colors.white,
          textSize: 24,
        ),
        onPressed: () {
          if (_tagBloc.getTagName() == null || _tagBloc.getTagName().isEmpty) {
            Fluttertoast.showToast(msg: "标题不能为空");
          } else {
            if (_tagBloc.isInit) {
              Navigator.of(context).pop(_tagBloc.getTagInfo());
              return;
            }
            Navigator.of(context).pop();
            NavigatorUtils.getInstance()
                .toTagRoute(context, _tagBloc.getTagInfo());
          }
        },
      ),
    );
  }

  /// 获取分类的widget，点击跳转搜索添加分类标签
  Widget getCategoryItem() {
    return StreamBuilder<List<String>>(
        stream: _tagBloc.getTagsStream(),
        builder: (context, data) {
          ///  把标签list转换成对应的chip控件显示
          List<Widget> children;
          if (data.data != null) {
            children = data.data
                .map((tagName) => CategoryItemWidget(
                      clickAble: true,
                      removeAble: true,
                      name: tagName,
                      removeCallback: (name) =>
                          _tagBloc.removeCategoryItem(name),
                    ))
                .toList();
          }
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                View(
                  child: Row(children: <Widget>[
                    TextView(
                      "标签 (最多三个)",
                      textSize: 24,
                      textColor: Colors.grey,
                    ).aligment(Alignment.centerLeft),
                    Spacer(),
                    Icon(Icons.add)
                  ]),
                ).padding(top: 12, bottom: 12).click(() {
                  int maxSize = 3 - (children?.length ?? 0);
                  if (maxSize == 0) {
                    return;
                  }
                  showSearch(
                          context: _context, delegate: CategorySearch(maxSize))
                      .then((results) {
                    if (results is Iterable && results.isNotEmpty) {
                      List<String> tags = [];
                      results.forEach((tag) {
                        tags.add(tag);
                      });
                      _tagBloc.addCategoryItem(tags);
                    }
                  });
                }),
                Wrap(
                  runAlignment: WrapAlignment.start,
                  children: children ?? [],
                  spacing: DP.toDouble(16),
                ),
              ]);
        });
  }
}
