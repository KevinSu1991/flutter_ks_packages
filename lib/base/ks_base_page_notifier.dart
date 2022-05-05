import 'dart:async';

import 'package:flutter_ks_packages/base/ks_base_notifier.dart';
import 'package:flutter_ks_packages/base/model/response_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class KSBasePageNotifier<T> extends KSBaseNotifier {
  late RefreshController refreshController;
  KSBasePageNotifier({bool initialRefresh = true}) {
    refreshController = RefreshController(initialRefresh: initialRefresh);
  }

  int currentPage = 1;
  final int pageSize = 10;
  bool hasMoreData = true;

  ///刷新同时执行的请求
  void additionRequestsWhenRefresh() {}

  List<T> dataList = [];
  Future<CustomResponse> refreshData() {
    additionRequestsWhenRefresh();

    currentPage = 1;
    hasMoreData = true;
    dataList.clear();
    return fetchData();
  }

  Future<CustomResponse> loadMoreData() {
    return fetchData();
  }

  Future<CustomResponse> fetchData();
}
