import 'package:rxdart/rxdart.dart';
import 'package:tag/base/bloc.dart';
import 'package:tag/entity/BuildTagInfo.dart';
import 'package:tag/entity/TodoEntity.dart';
import 'package:tag/util/DataProvider.dart';

class BuildTagBloc extends BlocBase {
  PublishSubject<String> _currentFuntion = PublishSubject();
  PublishSubject<int> _currentTime = PublishSubject();

  /// 选中的日期
  PublishSubject<DateTime> _selectDateStream = PublishSubject();
  PublishSubject<List<Todo>> _todoList = PublishSubject();

  static Set<String> _addCategoryTags = Set();

  /// 标签
  PublishSubject<List<String>> _tagsStream = PublishSubject();

  PublishSubject<String> getFuntionStrStream() => _currentFuntion;

  PublishSubject<List<String>> getTagsStream() => _tagsStream;

  PublishSubject<int> getSelectTimeStream() => _currentTime;

  PublishSubject<DateTime> getSelectDateStream() => _selectDateStream;

  PublishSubject<List<Todo>> getTodoListStream() => _todoList;

  List<Todo> getTodoList() => _todoLists;

  DateTime _selectDateTime = DateTime.now();

  String _tagName = "";

  List<Todo> _todoLists = List();

  bool isInit = false;
  BuildTagInfo _initInfo;

  /// 设置初始数据
  void initData(BuildTagInfo info) {
    if (isInit) {
      return;
    }
    if (info != null) {
      _initInfo = info;
      isInit = true;
      selectDate(DateTime.fromMicrosecondsSinceEpoch(info.dateInt * 1000));
      setTodoList(info.todo);
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
  void setTodoList(List<Todo> todoList) {
    if (todoList == null) {
      return;
    }
    _todoLists = todoList;
    _todoList.add(todoList);
  }

  /// 获取Tag的具体内容
  BuildTagInfo getTagInfo() {
    if (_initInfo != null) {
      _initInfo.tagName = _tagName;
      _initInfo.dateInt = _selectDateTime.millisecondsSinceEpoch;
      _initInfo.todo = _todoLists;
      return _initInfo;
    } else {
      return BuildTagInfo(
          tagName: _tagName,
          dateInt: _selectDateTime.millisecondsSinceEpoch,
          todo: _todoLists);
    }
  }

  void updateTag(Function callback) {
    getTagInfo().update().then((value) {
      callback(true);
    }, onError: (error) => callback(false));
  }

  void addNewTag(Function callback) {
    getTagInfo().save().then((value) {
      callback(true, value.objectId);
    }, onError: (error) => callback(false, null));
  }

  @override
  void dispose() {
    _tagsStream.close();
    _selectDateStream.close();
    _currentTime.close();
    _currentFuntion.close();
  }
}
