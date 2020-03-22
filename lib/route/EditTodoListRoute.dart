import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tag/entity/BuildTagInfo.dart';
import 'package:tag/entity/Constants.dart';

import 'package:tag/util/NaigatorUtils.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/TextView.dart';

/// 编辑Todo列表的页面
class EditTodoListRoute extends StatelessWidget {
  /// 初始化的name list
  List<Todo> initTodos;

  /// 当前的name list
  List<Todo> _nameItemStrs = List();

  List<EditTodoListItemWidget> _nameItemWidgets = List();

  Function nameCallback;

  FocusNode _focusNode;

  Function _focusCallback;

  PublishSubject<List<EditTodoListItemWidget>> _nameItemStream =
      PublishSubject();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextView("清单", textColor: Colors.white, textSize: 28),
        backgroundColor: HexColor(Constants.MAIN_COLOR),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(getTodos());
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              addNewItem();
            },
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: StreamBuilder<List<EditTodoListItemWidget>>(
          initialData:
              ((NavigatorUtils.getPreArguments(context)[Constants.DATA] ?? [])
                      as List<Todo>)
                  .map((data) => EditTodoListItemWidget(
                        nameEntity: data,
                        focusCallback: _focusCallback,
                        removeCallback: (item) {
                          _nameItemWidgets.remove(item);
                        },
                      ))
                  .toList(),
          stream: _nameItemStream,
          builder: (context, widgets) {
            /// 记录下来widgets以及对应的name文本
            _nameItemWidgets = widgets.data;
            _nameItemStrs =
                _nameItemWidgets.map((widget) => widget.getTodoInfo()).toList();
            return ReorderableListView(
                onReorder: (oldInex, newIndex) {
                  /// 改变被移动widget在list中的位置
                  EditTodoListItemWidget widget = _nameItemWidgets[oldInex];
                  _nameItemWidgets.remove(widget);
                  if (newIndex >= _nameItemWidgets.length) {
                    _nameItemWidgets.add(widget);
                  } else {
                    _nameItemWidgets.insert(newIndex, widget);
                  }
                  buildListItem(getTodos());
                },
                children: _nameItemWidgets);
          },
        ),
      ),
    );
  }

  /// 根据文本构建widgets，然后通过stream发射出去更新ui
  void buildListItem(List<Todo> datas) {
    List<EditTodoListItemWidget> widgets = datas
        .map((data) => EditTodoListItemWidget(
              nameEntity: data,
              focusCallback: _focusCallback,
              removeCallback: (item) {
                _nameItemWidgets.remove(item);
              },
            ))
        .toList();
    _nameItemStream.add(widgets);
  }

  /// 检查namelist的数据有没有变动
  bool checkTodoDataChange() {
    // 长度或者对应index的内容变动了就要给当前清单的数据重新赋值
    if (_nameItemWidgets.length != _nameItemStrs.length) {
      return true;
    }
    for (int i = 0; i < _nameItemWidgets.length; i++) {
      if (_nameItemWidgets[i].nameContent != _nameItemStrs[i]) {
        return true;
      }
    }
    return false;
  }

  /// 移除掉空的name
  void removeEmptyTodo() {
    if (_nameItemStrs.isEmpty) {
      return;
    }

    /// 过滤掉内容为空的itemWidget
    List<Widget> notEmptyWidgets = _nameItemWidgets
        .takeWhile((widget) => widget.nameContent.isNotEmpty)
        .toList();
    if (notEmptyWidgets.length != _nameItemStrs.length) {
      _nameItemStream.add(notEmptyWidgets);
    }
  }

  /// 新建一个空的清单输入框
  void addNewItem() {
    /// 过滤掉内容为空的itemWidget
    List<EditTodoListItemWidget> notEmptyWidgets = _nameItemWidgets
        .takeWhile((widget) => widget.nameContent.isNotEmpty)
        .toList();

    /// 去除焦点
    notEmptyWidgets.forEach((item) => item.foucs(false));

    /// 在list尾加入一个有焦点的空输入框
    notEmptyWidgets.add(EditTodoListItemWidget(
        nameEntity: Todo(isFinish: 0, name: ""),
        autoFocus: true,
        focusCallback: _focusCallback,
        removeCallback: (item) {
          _nameItemWidgets.remove(item);
        }));
    _nameItemStream.add(notEmptyWidgets);
  }

  /// 获取当前的name列表数据
  List<Todo> getTodos() {
    List<Todo> names = List();
    _nameItemWidgets.forEach((item) {
      if (item.getTodoInfo() != null) {
        names.add(item.getTodoInfo());
      }
    });
    return names;
  }
}

/// name的
class EditTodoListItemWidget extends StatelessWidget {
  final Function focusCallback;
  String nameContent;
  Function removeCallback;
  BuildContext _context;
  FocusNode _node = FocusNode();
  double height = 0;
  bool autoFocus;
  Todo nameEntity;

  EditTodoListItemWidget(
      {this.nameEntity,
      this.focusCallback,
      this.removeCallback,
      this.autoFocus = false})
      : super(key: UniqueKey()) {
    nameContent = nameEntity?.name ?? '';
  }

  Todo getTodoInfo() {
    nameEntity.name = nameContent;
    return nameEntity;
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return buildTodoItem(nameContent);
  }

  TextEditingController controller;

  void foucs(bool isFocus) {
    if (!isFocus) {
      _node.unfocus();
    }
    autoFocus = isFocus;
  }

  Widget buildTodoItem(String value) {
    controller = TextEditingController.fromValue(
        TextEditingValue(text: getTodoInfo()?.name ?? ""));
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (_) {
        removeCallback(this);
      },
      confirmDismiss: (value) {
        return showCupertinoDialog(
            context: _context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('确认移除该清单?'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('取消'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('确定'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            });
      },
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: Container(
          child: Icon(Icons.delete, color: Colors.white),
          margin: EdgeInsets.only(right: DP.toDouble(16)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            padding:
                EdgeInsets.only(left: DP.toDouble(16), right: DP.toDouble(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: DP.toDouble(24),
                  child: IconButton(
                    icon: Icon(
                      Icons.dehaze,
                      color: Colors.black,
                      size: DP.toDouble(20),
                    ),
                  ),
                ),
                SizedBox(
                  width: DP.toDouble(24),
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {
                      nameContent = value;
                    },
                    onSubmitted: (_) {
                      _node.unfocus();
                    },
                    focusNode: _node,
                    maxLines: null,
                    autofocus: autoFocus,
                    decoration: InputDecoration(
                        hintText: "输入清单内容",
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: HexColor(Constants.COLOR_BLUE))),
                        border: InputBorder.none),
                    style: TextView.getDefaultStyle(
                        fontSize: SP.get(30), textColor: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
          )
        ],
      ),
    );
  }
}
