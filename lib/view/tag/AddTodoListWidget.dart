import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tag/entity/Constants.dart';
import 'package:tag/util/util.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

class AddTodoListWidget extends StatelessWidget {
  /// 初始化的todo list
  List<String> initTodos;

  /// 当前的todo list
  List<String> currentTodos = List();

  List<EditTodoListItemWidget> todoItemWidgets = List();
  Function todoCallback;

  AddTodoListWidget({Key key, this.initTodos, this.todoCallback})
      : super(key: key) {
    if (initTodos == null || initTodos.length == 0) {
      initTodos = List();
    }
  }

  FocusNode _focusNode;

  Function _focusCallback;

  PublishSubject<List<String>> todoItemStream = PublishSubject();

  @override
  Widget build(BuildContext context) {
    _focusCallback = (node) {
      _focusNode = node;

      ///切换焦点的时候要检查一下有没有空的item，直接删除掉空的
      removeEmptyTodo();
    };
    return Container(
      child: GestureDetector(
        onTap: () {
          _focusNode?.unfocus();

          /// 点击空白处失去焦点的时候要检查一下有没有空的item，直接删除掉空的
          removeEmptyTodo();
        },
        child: StreamBuilder<List<String>>(
          stream: todoItemStream,
          initialData: initTodos,
          builder: (context, datas) {
            /// 每次更新listview的内容里，把所有itemwidgets和当前todo的string内容
            /// 清空，然后重新加进去
            todoItemWidgets.clear();
            currentTodos.clear();
            currentTodos.addAll(datas.data);
            return ListView.builder(
              itemCount: datas.data.length,
              itemBuilder: (context, index) {
                Widget child = EditTodoListItemWidget(
                  todoContent: datas.data[index],
                  focusCallback: _focusCallback,
                  removeCallback: (item) {
                    todoItemWidgets.remove(item);
                  },
                );
                todoItemWidgets.add(child);
                return child;
              },
            );
          },
        ),
      ),
    );
  }

  List<Widget> buildListItem(List<String> datas) {
    todoItemWidgets.clear();
    datas.forEach((todo) {
      todoItemWidgets.add(EditTodoListItemWidget(
        todoContent: todo,
        focusCallback: _focusCallback,
        removeCallback: (item) {
          todoItemWidgets.remove(item);
        },
      ));
    });
    return todoItemWidgets;
  }

  /// 检查todolist的数据有没有变动
  bool checkTodoDataChange() {
    // 长度或者对应index的内容变动了就要给当前清单的数据重新赋值
    if (todoItemWidgets.length != currentTodos.length) {
      return true;
    }
    for (int i = 0; i < todoItemWidgets.length; i++) {
      if (todoItemWidgets[i].todoContent != currentTodos[i]) {
        return true;
      }
    }
    return false;
  }

  void removeEmptyTodo() {
    if (currentTodos.isEmpty) {
      return;
    }
    List<String> todos = List();
    todoItemWidgets.forEach((item) => item.getTodoContent().isNotEmpty
        ? todos.add(item.getTodoContent())
        : null);
    if (todos.length != currentTodos.length) {
      todoItemStream.add(todos);
    }
  }

  void addNewItem() {
    if (currentTodos.last == null || currentTodos.isEmpty) {
      return;
    }
    List<String> todos = getTodos();
    todos.add("");
    todoItemStream.add(todos);
  }

  /// 获取当前的todo列表数据
  List<String> getTodos() {
    List<String> todos = List();
    todoItemWidgets.forEach((item) {
      todos.add(item.getTodoContent());
    });
    return todos;
  }
}

class EditTodoListItemWidget extends StatelessWidget {
  final Function focusCallback;
  String todoContent;
  Function removeCallback;
  BuildContext _context;

  EditTodoListItemWidget(
      {this.todoContent, this.focusCallback, this.removeCallback})
      : super(key: UniqueKey());

  String getTodoContent() => todoContent;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return buildTodoItem(todoContent);
  }

  TextEditingController controller;

  Widget buildTodoItem(String value) {
    FocusNode node = FocusNode();
    node.addListener(() {
      if (node.hasFocus) {
        focusCallback(node);
      }
    });
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
        children: <Widget>[
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            padding:
                EdgeInsets.only(left: DP.toDouble(16), right: DP.toDouble(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Icon(
                  Icons.brightness_1,
                  size: DP.toDouble(16),
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
                    focusNode: node,
                    maxLines: null,
                    decoration: InputDecoration(
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
