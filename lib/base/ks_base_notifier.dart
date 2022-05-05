import 'package:flutter/material.dart';

class KSBaseNotifier extends ChangeNotifier {
  ///刷新
  reload() {
    notifyListeners();
  }

  ///回收处理
  onDispose() {}
}
