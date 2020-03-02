import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/NaigatorUtils.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/TextView.dart';

/// 编辑Todo列表的页面
class EditTodoListRoute extends StatelessWidget {
  /// 初始化的todo list
  List<String> initTodos;

  /// 当前的todo list
  List<String> _todoItemStrs = List();

  List<EditTodoListItemWidget> _todoItemWidgets = List();

  Function todoCallback;

  FocusNode _focusNode;

  Function _focusCallback;

  PublishSubject<List<EditTodoListItemWidget>> _todoItemStream =
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
                      as List<String>)
                  .map((data) => EditTodoListItemWidget(
                        todoContent: data,
                        focusCallback: _focusCallback,
                        removeCallback: (item) {
                          _todoItemWidgets.remove(item);
                        },
                      ))
                  .toList(),
          stream: _todoItemStream,
          builder: (context, widgets) {
            /// 记录下来widgets以及对应的todo文本
            _todoItemWidgets = widgets.data;
            _todoItemStrs = _todoItemWidgets
                .map((widget) => widget.getTodoContent())
                .toList();
            print(getTodos());
            return ReorderableListView(
                onReorder: (oldInex, newIndex) {
                  /// 改变被移动widget在list中的位置
                  EditTodoListItemWidget widget = _todoItemWidgets[oldInex];
                  _todoItemWidgets.remove(widget);
                  if (newIndex >= _todoItemWidgets.length) {
                    _todoItemWidgets.add(widget);
                  } else {
                    _todoItemWidgets.insert(newIndex, widget);
                  }
                  buildListItem(getTodos());
                },
                children: _todoItemWidgets);
          },
        ),
      ),
    );
  }

  /// 根据文本构建widgets，然后通过stream发射出去更新ui
  void buildListItem(List<String> datas) {
    List<EditTodoListItemWidget> widgets = datas
        .map((data) => EditTodoListItemWidget(
              todoContent: data,
              focusCallback: _focusCallback,
              removeCallback: (item) {
                _todoItemWidgets.remove(item);
              },
            ))
        .toList();
    _todoItemStream.add(widgets);
  }

  /// 检查todolist的数据有没有变动
  bool checkTodoDataChange() {
    // 长度或者对应index的内容变动了就要给当前清单的数据重新赋值
    if (_todoItemWidgets.length != _todoItemStrs.length) {
      return true;
    }
    for (int i = 0; i < _todoItemWidgets.length; i++) {
      if (_todoItemWidgets[i].todoContent != _todoItemStrs[i]) {
        return true;
      }
    }
    return false;
  }

  /// 移除掉空的todo
  void removeEmptyTodo() {
    if (_todoItemStrs.isEmpty) {
      return;
    }

    /// 过滤掉内容为空的itemWidget
    List<Widget> notEmptyWidgets = _todoItemWidgets
        .takeWhile((widget) => widget.todoContent.isNotEmpty)
        .toList();
    if (notEmptyWidgets.length != _todoItemStrs.length) {
      _todoItemStream.add(notEmptyWidgets);
    }
  }

  /// 新建一个空的清单输入框
  void addNewItem() {
    /// 过滤掉内容为空的itemWidget
    List<EditTodoListItemWidget> notEmptyWidgets = _todoItemWidgets
        .takeWhile((widget) => widget.todoContent.isNotEmpty)
        .toList();

    /// 去除焦点
    notEmptyWidgets.forEach((item) => item.foucs(false));

    /// 在list尾加入一个有焦点的空输入框
    notEmptyWidgets.add(EditTodoListItemWidget(
        autoFocus: true,
        focusCallback: _focusCallback,
        removeCallback: (item) {
          _todoItemWidgets.remove(item);
        }));
    _todoItemStream.add(notEmptyWidgets);
  }

  /// 获取当前的todo列表数据
  List<String> getTodos() {
    List<String> todos = List();
    _todoItemWidgets.forEach((item) {
      if (item.getTodoContent().isNotEmpty) {
        todos.add(item.getTodoContent());
      }
    });
    return todos;
  }
}

class EditTodoListItemWidget extends StatelessWidget {
  final Function focusCallback;
  String todoContent;
  Function removeCallback;
  BuildContext _context;
  FocusNode _node = FocusNode();
  double height = 0;
  bool autoFocus;

  EditTodoListItemWidget(
      {this.todoContent = "",
      this.focusCallback,
      this.removeCallback,
      this.autoFocus = false})
      : super(key: UniqueKey());

  String getTodoContent() => todoContent;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return buildTodoItem(todoContent);
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
        TextEditingValue(text: getTodoContent()));
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
                      todoContent = value;
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
