import 'dart:collection';

import 'package:flutter/cupertino.dart';

///
/// * author : kyle
/// * time   : 2019/9/12
/// * desc   : bloc封装,作为一个基类,调用[of]方法获取到对应泛型类型的一个[BlocBase]对象
/// 业务逻辑新建一个类继承[BlocBase],在[BlocBase.dispose]方法里释放资源，比如stream流的监听等等，会在对应的state销毁的时候自动释放资源
/// 但是有时候不希望自动释放资源的时候，可以[BlocBase.autoRelease]里返回false，比如跨页面使用bloc的时候，bloc可以写成单例模式
/// 至于资源的释放可以在不需要的时候自己手动调用[BlocBase.dispose]
///
/// * 使用 : 一个页面一般用[BlocProvider]作为顶层widget,创建一个[BlocBase]作为参数,子widget通过[BlocProvider.of]方法
/// 获取对应泛型类型的bloc类，要使用多个bloc的时候只要把[BlocProvider]作为节点，of方法会根据传入的泛型对应找到节点的bloc并且返回,要用到
///

Type _typeOf<T>() => T;

/// bloc基类,业务逻辑类继承这个类
abstract class BlocBase {
  /// 是否自动释放资源，默认为true，如果自动释放会在对应state销毁时调用[dispose]
  bool autoRelease() => true;


  void dispose();
}

///  用[StatefulWidget]作为顶层widget，方便释放资源，内部child用[InheritedWidget],便于子节点找到对应的[BlocBase]
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  final Widget child;
  final T bloc;
  HashMap<int, BlocBase> _blocMap;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<_BlocProviderInherited<T>>();
    _BlocProviderInherited<T> provider = context.ancestorInheritedElementForWidgetOfExactType(type)?.widget;
    return provider?.bloc;
  }

  /// 根据[key]找到[_blocMap]中的[BlocBase],
  T getBloc<T extends BlocBase>(int key) {
    if (_blocMap.isEmpty || _blocMap == null) {
      return null;
    }
    return _blocMap[key];
  }

  /// 把[blocBase]放到[_blocMap]中，然后通过[getBloc]方法获取到[blocBase]
  /// 使用场景:一个顶层widget有一个[BlocProvider],对应一个[blocBase],但是有时候需要拆分更细致，或者子widget之间需要共用一部分逻辑，
  /// 可以添加多一个[blocBase],用的时候调用[getBloc]去调用
  putBlock(int key, BlocBase blocBase) {
    if (_blocMap == null) {
      _blocMap = HashMap();
    }
    _blocMap[key] = blocBase;
  }
}

class _BlocProviderState<T extends BlocBase> extends State<BlocProvider<T>> {
  @override
  void dispose() {
    widget.bloc?.dispose();

    /// 遍历map，释放资源
    if (widget._blocMap != null && widget._blocMap.isNotEmpty) {
      widget._blocMap.forEach((key, value) {
        if (value != null && value.autoRelease()) {
          value.dispose();
        }
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new _BlocProviderInherited<T>(
      bloc: widget.bloc,
      child: widget.child,
    );
  }
}

class _BlocProviderInherited<T> extends InheritedWidget {
  _BlocProviderInherited({
    Key key,
    @required Widget child,
    @required this.bloc,
  }) : super(key: key, child: child);

  final T bloc;

  @override
  bool updateShouldNotify(_BlocProviderInherited oldWidget) => false;
}
