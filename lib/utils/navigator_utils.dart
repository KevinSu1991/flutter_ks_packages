import 'package:flutter/cupertino.dart';

class KSNavigatorUtils {
  static void pushPageWithRoute(GlobalKey<NavigatorState> navigatorKey, PageRoute pageRoute) {
    navigatorKey.currentState?.push(pageRoute);
  }

  static void popToLast(GlobalKey<NavigatorState> navigatorKey) {
    navigatorKey.currentState?.pop();
  }

  static void popToFirst(GlobalKey<NavigatorState> navigatorKey) {
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  static void popByCount(GlobalKey<NavigatorState> navigatorKey, int popCount) {
    int count = 0;
    navigatorKey.currentState?.popUntil((_) => count++ >= popCount);
  }

  ///IOS Style
  static void pushPage(GlobalKey<NavigatorState> navigatorKey, Widget page, {bool animated = true}) {
    if (animated) {
      navigatorKey.currentState?.push(CupertinoPageRoute(builder: (ctx) => page));
    } else {
      navigatorKey.currentState?.push(PageRouteBuilder(pageBuilder: (context, animation1, animation2) => page, transitionDuration: Duration.zero));
    }
  }

  static void presentPage(GlobalKey<NavigatorState> navigatorKey, Widget page) {
    navigatorKey.currentState?.push(CupertinoPageRoute(builder: (ctx) => page, fullscreenDialog: true));
  }

  static void replacePage(GlobalKey<NavigatorState> navigatorKey, Widget page) {
    navigatorKey.currentState
        ?.pushReplacement(PageRouteBuilder(pageBuilder: (context, animation1, animation2) => page, transitionDuration: Duration.zero));
  }
}
