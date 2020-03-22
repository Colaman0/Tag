import 'package:rxdart/rxdart.dart';
import 'package:tag/base/bloc.dart';
import 'package:tag/entity/BuildFlagInfo.dart';
import 'package:tag/entity/Constants.dart';

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

  DateTime _selectDateTime = DateTime.now();

  BuildFlagInfo _initInfo;

  String _flagTitle = "";

  /// 初始化信息
  void init(BuildFlagInfo info) {
    if (_initInfo == null && info != null) {
      _initInfo = info;
      _flagTitle = info.flagName;
      selectDate(DateTime.fromMicrosecondsSinceEpoch(info.dateInt));
      addCategoryItem(info.categories);
    }
  }

  BuildFlagInfo getInitInfo() => _initInfo;

  bool isInit() => _initInfo != null;

  void selectDate(DateTime dateTime) {
    _selectDateTime = dateTime;
    getSelectDateStream().add(dateTime);
  }

  void setFlagName(String name) => _flagTitle = name;

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

  BuildFlagInfo buildFlagInfo() {
    return BuildFlagInfo(
        dateInt: getSelectDate().millisecondsSinceEpoch,
        flagName: getTitle(),
        categories: _addCategoryTags.toList(),
        backgroundType: _initInfo?.backgroundType ?? BackgroundType.COLOR,
        backgroundImage: _initInfo?.backgroundImage,
        backgroundColor: _initInfo?.backgroundColor ?? Constants.MAIN_COLOR);
  }

  String getTitle() => _flagTitle;

  @override
  void dispose() {
    _tagsStream.close();
    _selectDateStream.close();
    _currentTime.close();
    _currentFunction.close();
  }
}
