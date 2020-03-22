import 'package:data_plugin/bmob/table/bmob_object.dart';

class BuildTagInfo extends BmobObject {
  String id;
  String tagName;
  int dateInt;
  List<Todo> todo;

  BuildTagInfo({this.id, this.tagName, this.dateInt, this.todo});

  DateTime getDate() => DateTime.fromMicrosecondsSinceEpoch(dateInt * 1000);

  BuildTagInfo.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    id = json['id'];
    tagName = json['tagName'];
    dateInt = json['date'];
    if (json['todo'] != null) {
      todo = new List<Todo>();
      json['todo'].forEach((v) {
        todo.add(new Todo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tagName'] = this.tagName;
    data['objectId'] = getObjectId();
    data['date'] = this.dateInt;
    if (this.todo != null) {
      data['todo'] = this.todo.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  Map getParams() {
    return toJson();
  }
}

class Todo {
  int isFinish;
  String name;

  Todo({this.isFinish, this.name});

  Todo.fromJson(Map<String, dynamic> json) {
    isFinish = json['isFinish'];
    name = json['name'];
  }

  void setFinish(bool isFinish) => this.isFinish = isFinish ? 1 : 0;

  bool isTodoFinish() => isFinish == 1;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isFinish'] = this.isFinish;
    data['name'] = this.name;
    return data;
  }
}
