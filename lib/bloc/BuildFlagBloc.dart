import 'package:rxdart/rxdart.dart';
import 'package:tag/base/bloc.dart';
import 'package:tag/entity/BuildFlagInfo.dart';

class BuildFlagBloc extends BlocBase {
  PublishSubject<String> _currentFunction = PublishSubject();
  PublishSubject<int> _currentTime = PublishSubject();

  /// 选中的日期
  PublishSubject<DateTime> _selectDateStream = PublishSubject();

  static Set<String> _addCategoryTags = Set();

  /// 标签
  PublishSubject<List<String>> _tagsStream = PublishSubject();

  PublishSubject<String> getFuntionStrStream() => _currentFunction;

  PublishSubject<List<String>> getTagsStream() => _tagsStream;

  PublishSubject<int> getSelectTimeStream() => _currentTime;

  PublishSubject<DateTime> getSelectDateStream() => _selectDateStream;


  DateTime _selectDateTime;

  void selectDate(DateTime dateTime) {
    _selectDateTime = dateTime;
    getSelectDateStream().add(dateTime);
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

  BuildFlagInfo buildFlagInfo(String name) {
    return BuildFlagInfo(
        date: _selectDateTime,
        flagName: name,
        categories: _addCategoryTags.toList());
  }

  @override
  void dispose() {
    _tagsStream.close();
    _selectDateStream.close();
    _currentTime.close();
    _currentFunction.close();
  }
}
