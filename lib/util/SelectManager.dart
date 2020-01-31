import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

typedef UpdateFunction<T> = bool Function(T key);

class SelectManager<T> {
  /// 是否允许取消（重复选中）
  final bool canCancel;

  /// 最多选中的数量
  final int maxSize;

  /// 最少选中的数量
  final int lowSize;

  final List<SelectItem<T>> _items = List();
  final List<T> _selectKeys = List();

  UpdateFunction<T> updateFunction;

  int _currentSelectSize = 0;

  SelectManager({
    this.canCancel = true,
    this.maxSize = 1,
    this.lowSize = 0,
    this.updateFunction,
    List<SelectItem<T>> datas,
    List<T> selectKeys,
  }) {
    if (selectKeys != null && selectKeys.isNotEmpty) {
      _selectKeys.addAll(selectKeys);
    }
    updateDatas(datas);
  }

  //把传进来的items添加进去，并且改变item 的状态
  void updateDatas(List<SelectItem<T>> datas, {bool removeSelect = true}) {
    if (removeSelect) {
      _currentSelectSize = 0;
      _selectKeys.clear();
    }
    _items.clear();
    if (datas != null && datas.isNotEmpty) {
      _items.addAll(datas);
      datas.forEach((item) {
        /// 把当前selectManager传给item，方便点击的时候调用
        item.injectSelectManager(this);

        ///  当有默认选中的key时，遍历一下所有item，匹配到的改变一下状态
        if (_selectKeys != null && _selectKeys.isNotEmpty) {
          bool inside = _selectKeys.indexOf(item.getItemKey()) >= 0;
          if (inside) {
            _currentSelectSize += inside ? 1 : 0;
            item.changeStatus(true);
            _selectKeys.add(item.getItemKey());
          }
        }
      });
    }
  }

  /// 当item选中/未选中的时候调用此方法，只要把原本的item传进即可
  void checkItem(SelectItem<T> item) {
    if (_items.indexOf(item) >= 0) {
      // 如果要操作的item是选中状态，那么要检测一下lowSize
      if (item.currentSelectStatus && _currentSelectSize - 1 >= lowSize) {
        _currentSelectSize -= 1;
        _selectKeys.remove(item.getItemKey());
        item.changeStatus(false);
        return;
      }
      // 如果要操作的item是未选中状态，那么要检测一下maxSize
      if (!item.currentSelectStatus && _currentSelectSize + 1 <= maxSize) {
        _currentSelectSize += 1;
        _selectKeys.add(item.getItemKey());
        item.changeStatus(true);
        return;
      }
    }
  }

  List<T> getSelectResults() => _selectKeys;
}

/// 作为selectManager要处理的item载体需要实现的类，
/// 比如一个listview的item，一个chip，
abstract class SelectItem<T> {
  SelectManager _selectManager;
  bool currentSelectStatus = false;

  bool getCurrentSelectStatus() => currentSelectStatus;

  SelectManager getSelectManager() => _selectManager;

  void injectSelectManager(SelectManager manager) {
    _selectManager = manager;
  }

  /// 返回一个唯一的key {
  T getItemKey();

  /// 在这里改变当前item选中/未选中的UI
  void changeStatus(bool isSelect) {
    currentSelectStatus = isSelect;
  }
}
