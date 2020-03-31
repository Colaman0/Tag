import 'package:tag/entity/BuildTagInfo.dart';

class TagDataManager {
  static TagDataManager _instance;

  TagDataManager._();

  static TagDataManager getInstance() {
    if (_instance == null) {
      _instance = TagDataManager._();
    }
    return _instance;
  }

  List<BuildTagInfo> getTagDatas({List<Function> functions}) {
    List<BuildTagInfo> infos = List();

  }


}
