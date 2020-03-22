import 'package:data_plugin/bmob/bmob.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tag/entity/BuildFlagInfo.dart';
import 'package:tag/entity/BuildTagInfo.dart';

class DataProvider {
  static DataProvider _instance;

  DataProvider._();

  static DataProvider getInstance() {
    if (_instance == null) {
      _instance = DataProvider._();
      Bmob.init("https://api2.bmob.cn", "bce357bf5613bada08b451330b3d5972",
          "4ac648ed7b8885a61d446e78fa794926");
    }
    return _instance;
  }

  PublishSubject<List<BuildTagInfo>> _tagDataStream = PublishSubject();
  PublishSubject<List<BuildFlagInfo>> _flagDataStream = PublishSubject();

  PublishSubject<List<BuildTagInfo>> _tagSearchStream = PublishSubject();
  PublishSubject<List<BuildFlagInfo>> _flagSearchStream = PublishSubject();

  PublishSubject<List<BuildTagInfo>> getTagDataStream() => _tagDataStream;

  PublishSubject<List<BuildFlagInfo>> getFlagDataStream() => _flagDataStream;

  PublishSubject<List<BuildTagInfo>> getTagSearchStream() => _tagSearchStream;

  PublishSubject<List<BuildFlagInfo>> getFlagSearchStream() =>
      _flagSearchStream;

  List<BuildTagInfo> tags = List();

  Future<List<BuildTagInfo>> searchTag(String query) {
    return Future.value();
  }

  Future<List<BuildFlagInfo>> searchFlag(String query) {
    return Future.value();
  }

  void addNewTagToStream(BuildTagInfo info) {
    tags.add(info);
    getTagDataStream().add(tags);
  }

  void getAllTagData() {
    BmobQuery<BuildTagInfo> query = BmobQuery();
    query.queryObjects().then((datas) {
      tags.clear();
      tags.addAll(datas.map((data) => BuildTagInfo.fromJson(data)).toList());
      getTagDataStream().add(tags);
    });
  }
}
