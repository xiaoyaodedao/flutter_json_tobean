import 'package:first_flutter/beans/bean.dart';

import 'http_manager.dart';

class Api {
  static const String baseUrl = "https://www.wanandroid.com/";

  //首页文章列表 http://www.wanandroid.com/article/list/0/json
  static const String ARTICLE_LIST = "article/list/";

  static const String BANNER = "banner/json";

  static Future<Resource<HomeData>> getArticleList(int page) async {
    return HttpManager.getInstance()
        .requestObject('$ARTICLE_LIST$page/json', HomeData());
  }

  static Future<Resource<List<BannerData>>> getBanner() async {
    return await HttpManager.getInstance().requestList(BANNER, BannerData());
  }
}
