import 'dart:io';

enum BackgroundType { IMAGE, COLOR }

class BuildFlagInfo {
  String id;
  int backgroundType;
  String flagName;
  int dateInt;
  String backgroundImage;
  String backgroundColor;
  List<String> categories;
  File backgroundFile;

  BuildFlagInfo(
      {this.id,
      this.backgroundType,
      this.flagName,
      this.dateInt,
      this.backgroundImage,
      this.backgroundColor,
      this.categories});

  BuildFlagInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    backgroundType = json['backgroundType'];
    flagName = json['flagName'];
    dateInt = json['date'];
    backgroundImage = json['backgroundImage'];
    backgroundColor = json['backgroundColor'];
    categories = json['categories'].cast<String>();
  }

  DateTime getDate() => DateTime.fromMicrosecondsSinceEpoch(dateInt);

  BackgroundType getBackgroundType() =>
      backgroundType == 0 ? BackgroundType.COLOR : BackgroundType.IMAGE;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['backgroundType'] = this.backgroundType;
    data['flagName'] = this.flagName;
    data['date'] = this.dateInt;
    data['backgroundImage'] = this.backgroundImage;
    data['backgroundColor'] = this.backgroundColor;
    data['categories'] = this.categories;
    return data;
  }

  /// 设置背景图片file
  void setImage(File file) {
//      backgroundImage = file;
  }

  void setColor(String colorStr) {
//      this.colorStr = colorStr;
  }

  void setBackgroundType(BackgroundType type) {
//      backgroundType = type;
  }
}
