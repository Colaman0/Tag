import 'package:tag/entity/TodoEntity.dart';

class BuildTagInfo {
  final String tagName;
  final DateTime date;
  List<TodoEntity> todos;

  BuildTagInfo({this.tagName, this.date, this.todos});
}
