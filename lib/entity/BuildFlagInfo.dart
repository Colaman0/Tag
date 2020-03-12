import 'dart:io';

enum BackgroundType { IMAGE, COLOR }

class BuildFlagInfo {
  BackgroundType backgroundType;
  final String flagName;

  final DateTime date;
  File backgroundImage;
  String colorStr = "#80000000";
  List<String> categories;

  BuildFlagInfo(
      {this.flagName = "",
      this.date,
      this.backgroundType,
      this.backgroundImage,
      this.colorStr,
      this.categories});

  /// 设置背景图片file
  void setImage(File file) {
    backgroundImage = file;
  }

  void setColor(String colorStr) {
    this.colorStr = colorStr;
  }

  void setBackgroundType(BackgroundType type) {
    backgroundType = type;
  }
}
