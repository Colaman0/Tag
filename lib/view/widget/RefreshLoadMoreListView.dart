import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tag/view/main/MainContentsWidget.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

import 'BaseWidget.dart';

class RefreshLoadmoreListView extends StatefulWidget {
  final RLDataFactory _dataFactory;
  final RefreshLoadmoreOption _option;

  RefreshLoadmoreListView(this._dataFactory, this._option);

  @override
  _RefreshLoadmoreListViewState createState() =>
      _RefreshLoadmoreListViewState(_dataFactory, _option);
}

class RefreshLoadmoreOption {
  final bool canLoadMore;

  final bool canRefresh;

  Widget loadMoreItem;

  RefreshLoadmoreOption(
      {Key key,
      this.canLoadMore = true,
      this.canRefresh = true,
      this.loadMoreItem});
}

class _RefreshLoadmoreListViewState extends State<RefreshLoadmoreListView>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  final RLDataFactory _dataFactory;
  final RefreshLoadmoreOption _option;
  final PageDataHelper _pageHelper = new PageDataHelper();
  final ScrollController _scrollController = ScrollController();

  bool loadmoreIng = false;
  bool refreshIng = false;

  _RefreshLoadmoreListViewState(this._dataFactory, this._option);

  Future<PageDTO<dynamic>> _refrshFuture;
  Widget child;

  @override
  void initState() {
    super.initState();
//    _controller = AnimationController(vsync: this);
//    _animation = Tween(
//      begin: 0.0,
//      end: 1.0,
//    ).animate(_controller);
    child = getAnimBase();
    _refrshFuture = _dataFactory.createFuture(_pageHelper.currentPage);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        /// 避免重复loadmore / 以下拉刷新为标准
        if (loadmoreIng || refreshIng) {
          return;
        }
        loadmoreIng = true;
        loadmore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); //必须添加
    return FutureBuilder<PageDTO>(
        future: _refrshFuture,
        builder: (context, snapshot) {
          print(snapshot.toString());
//          switch (snapshot.connectionState) {
//            case ConnectionState.none:
//            case ConnectionState.active:
//            case ConnectionState.waiting:
//            case ConnectionState.done:
//              if (snapshot.hasError) {
//                return Center(
//                  child: TextView('网络请求出错,点击重试').click(() => refresh()),
//                );
//              } else {
//                return child;
//              }
//          }
          loadmoreIng = false;
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError) {
            /// future返回数据之后注入到pageHelper里进行处理
            _pageHelper.injectData(snapshot.data);
          }
          return AnimatedCrossFade(
            duration: Duration(seconds: 1),
            // ignore: unrelated_type_equality_checks
            crossFadeState: snapshot.connectionState == ConnectionState.done
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Center(
              child: CircularProgressIndicator(),
            ),
            secondChild: child,
          );
        });
  }

  Widget getAnimBase() {
    return View(
      child: TextView("12"),
    )
        .touchAnimation(false)
        .backgroundColor(Colors.black)
        .size(width: View.MATCH, height: View.MATCH)
        .click(() {
      refresh();
    });
  }

  void loadmore() async {
    var data = await _dataFactory.createFuture(_pageHelper.currentPage + 1);

    /// 不影响下拉刷新
    if (!refreshIng) {
      setState(() {
        _pageHelper.injectData(data);
      });
    }
  }

  //todo 刷新listview会闪烁
  refresh() async {
    refreshIng = true;
    _pageHelper.reset();
    var datas = await _dataFactory.createFuture(_pageHelper.currentPage);
    setState(() {
      _refrshFuture = Future.delayed(Duration(seconds: 2), () {
        return Future.value(datas);
      });
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class PageDataHelper {
  List datas = List();

  int currentPage = 1;

  bool isLastPage = true;

  void reset() {
    datas.clear();
    currentPage = 1;
  }

  void injectData(PageDTO pageDTO) {
    datas.addAll(pageDTO.getDatas());
    isLastPage = pageDTO.isLastPage();
  }
}

abstract class RLDataFactory<T> {
  Future<PageDTO<T>> createFuture(int page);

  Widget createItemWidget(BuildContext context, int index, dynamic data);
}

abstract class PageDTO<T> {
  List<T> getDatas();

  bool isLastPage();
}
