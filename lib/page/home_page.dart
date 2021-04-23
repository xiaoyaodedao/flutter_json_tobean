import 'package:banner_view/banner_view.dart';
import 'package:first_flutter/beans/bean.dart';
import 'package:first_flutter/http/api.dart';
import 'package:first_flutter/http/http_manager.dart';
import 'package:first_flutter/page/home_list_item.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isHidden = true;
  RefreshController _refreshController = RefreshController();
  ScrollController _scrollController = ScrollController();

  //list
  List<HomeItemDatas> _data = [];

  //banner
  List<BannerData> _banner = [];

  //
  int _currentPage = 0;
  int _totalPage;

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    var listItemCount = _banner.isNotEmpty ? _data.length + 1 : _data.length;
    return Stack(
      children: [
        SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView.builder(
            itemBuilder: listItem,
            controller: _scrollController,
            itemCount: listItemCount,
          ),
        ),
        Offstage(
          offstage: !_isHidden,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
      ],
    );
  }

  Widget listItem(context, index) {
    if (_banner.isNotEmpty && index == 0) {
      return buildBanner();
    } else {
      return HomeListItem(_data[_banner.isNotEmpty ? index - 1 : index]);
    }
  }

  Widget buildBanner() {
    var imageList = _banner
        .map((e) => Image.network(
              e.imagePath,
              fit: BoxFit.cover,
            ))
        .toList();
    return Container(
      height: 180,
      child: BannerView(
        imageList,
        intervalDuration: const Duration(seconds: 3),
      ),
    );
  }

  void _onRefresh() async {
    _currentPage = 0;
    _isHidden = true;
    setState(() {});
    Iterable<Future> future = [_getBannerData(false,true), _getHomeList(false,true)];
    await Future.wait(future);
    _isHidden = false;
    setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (_currentPage >= _totalPage) {
      return;
    }
    _isHidden = true;
    setState(() {});
    _getHomeList();
    _refreshController.loadComplete();
  }

  _getBannerData([bool update = true,bool isRefreshData = false]) async {
    if(isRefreshData){
      _banner = [];
    }
    var banner = await Api.getBanner();
    if (banner.status == ResourceStatus.SUCCESS) {
      _banner = banner.data;
    }
    if (update) {
      setState(() {});
    }
  }

  _getHomeList([bool update = true,bool isRefreshData = false]) async {
    if(isRefreshData){
      _data = [];
      _totalPage = -1;
    }
    var homeData = await Api.getArticleList(_currentPage);
    if (homeData.status == ResourceStatus.SUCCESS) {
      _totalPage = homeData.data.pageCount;
      _currentPage = homeData.data.curPage;
      _data.addAll(homeData.data.datas);
    }
    _isHidden = false;
    if (update) {
      setState(() {});
    }
  }
}
