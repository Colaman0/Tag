import 'package:flutter/cupertino.dart';
import 'package:tag/bloc/BuildTagBloc.dart';

///
/// 新建Flag/Tag的pageview中每个page都需要实现，用于校验当前page的数据填写是否符合
/// 以及展示不符合规则的tips用于展示
///
abstract class BasePage {
  BuildTagBloc _tagBloc;

  BasePage injectBloc(BuildTagBloc bloc) {
    _tagBloc = bloc;
    return this;
  }

  BuildTagBloc getTagBloc() => _tagBloc;

  void saveData();

  bool dataVaild();

  String dataTips();
}
