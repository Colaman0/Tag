import 'package:rxdart/rxdart.dart';
import 'package:tag/base/bloc.dart';

class BuildTagBloc extends BlocBase {
  PublishSubject<String> _currentFuntion = PublishSubject();
  PublishSubject<int> _currentTime = PublishSubject();

  /// 选中的日期
  PublishSubject<DateTime> _selectDateStream = PublishSubject();

  static Set<String> _addCategoryTags = Set();

  /// 标签
  PublishSubject<List<String>> _tagsStream = PublishSubject();

  PublishSubject<String> getFuntionStrStream() => _currentFuntion;

  PublishSubject<List<String>> getTagsStream() => _tagsStream;

  PublishSubject<int> getSelectTimeStream() => _currentTime;

  PublishSubject<DateTime> getSelectDateStream() => _selectDateStream;
  DateTime _selectDateTime;

  void selectDate(DateTime dateTime) {
    getSelectDateStream().add(dateTime);
    _selectDateTime = dateTime;
  }

  DateTime getSelectDate() => _selectDateTime;

  /// 添加分类标签
  void addCategoryItem(List<String> items) {
    if(items!=null && items.isNotEmpty) {
      _addCategoryTags.addAll(items.toSet());
      getTagsStream().add(_addCategoryTags.toList());
    }
  }

  void removeCategoryItem(String name) {
    _addCategoryTags.remove(name);
    getTagsStream().add(_addCategoryTags.toList());
  }

  @override
  void dispose() {
    _tagsStream.close();
    _selectDateStream.close();
    _currentTime.close();
    _currentFuntion.close();
  }
}
