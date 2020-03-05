import 'package:rxdart/rxdart.dart';
import 'package:tag/base/bloc.dart';
import 'package:tag/entity/BuildTagInfo.dart';
import 'package:tag/entity/TodoEntity.dart';

class BuildTagBloc extends BlocBase {
  PublishSubject<String> _currentFuntion = PublishSubject();
  PublishSubject<int> _currentTime = PublishSubject();

  /// 选中的日期
  PublishSubject<DateTime> _selectDateStream = PublishSubject();
  PublishSubject<List<TodoEntity>> _todoList = PublishSubject();

  static Set<String> _addCategoryTags = Set();

  /// 标签
  PublishSubject<List<String>> _tagsStream = PublishSubject();

  PublishSubject<String> getFuntionStrStream() => _currentFuntion;

  PublishSubject<List<String>> getTagsStream() => _tagsStream;

  PublishSubject<int> getSelectTimeStream() => _currentTime;

  PublishSubject<DateTime> getSelectDateStream() => _selectDateStream;

  PublishSubject<List<TodoEntity>> getTodoListStream() => _todoList;

  List<TodoEntity> getTodoList() => _todoLists;

  DateTime _selectDateTime = DateTime.now();

  String _tagName = "";

  List<TodoEntity> _todoLists = List();

  bool isInit = false;

  /// 设置初始数据
  void initData(BuildTagInfo info) {
    if (isInit) {
      return;
    }
    if (info != null) {
      isInit = true;
      selectDate(info.date);
      setTodoList(info.todos);
      _tagName = info.tagName;
    }
  }

  void selectDate(DateTime dateTime) {
    _selectDateTime = dateTime;
    getSelectDateStream().add(dateTime);
  }

  String getTagName() => _tagName;

  void setTagName(String name) {
    _tagName = name;
  }

  DateTime getSelectDate() => _selectDateTime;

  /// 添加分类标签
  void addCategoryItem(List<String> items) {
    if (items != null && items.isNotEmpty) {
      _addCategoryTags.addAll(items.toSet());
      getTagsStream().add(_addCategoryTags.toList());
    }
  }

  void removeCategoryItem(String name) {
    _addCategoryTags.remove(name);
    getTagsStream().add(_addCategoryTags.toList());
  }

  /// 设置todolist内容
  void setTodoList(List<TodoEntity> todoList) {
    if (todoList == null) {
      return;
    }
    _todoLists = todoList;
    _todoList.add(todoList);
  }

  /// 获取Tag的具体内容
  BuildTagInfo getTagInfo() =>
      BuildTagInfo(tagName: _tagName, date: _selectDateTime, todos: _todoLists);

  @override
  void dispose() {
    _tagsStream.close();
    _selectDateStream.close();
    _currentTime.close();
    _currentFuntion.close();
  }
}
