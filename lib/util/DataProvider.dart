import 'package:rxdart/rxdart.dart';
import 'package:tag/entity/BuildFlagInfo.dart';
import 'package:tag/entity/BuildTagInfo.dart';

class DataProvider {
  static DataProvider _instance;

  DataProvider._();

  static DataProvider getInstance() {
    if (_instance == null) {
      _instance = DataProvider._();
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

  Future<List<BuildTagInfo>> searchTag(String query) {
    return Future.value();
  }

  Future<List<BuildFlagInfo>> searchFlag(String query) {
    return Future.value();
  }
}
