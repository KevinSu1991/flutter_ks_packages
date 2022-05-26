import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class KSEChartsWidget extends StatefulWidget {
  final String option;
  const KSEChartsWidget({Key? key, required this.option}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _KSEChartsWidgetState();
}

class _KSEChartsWidgetState extends State<KSEChartsWidget> {
  InAppWebViewController? _inAppWebViewController;

  double _webViewOpacity = 0;

  String? _currentOption;

  @override
  void initState() {
    super.initState();

    _currentOption = widget.option;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _webViewOpacity,
      child: InAppWebView(
        initialFile: "packages/flutter_ks_packages/assets/echarts/echarts.html",
        initialOptions: InAppWebViewGroupOptions(
          android: AndroidInAppWebViewOptions(useWideViewPort: false),
          crossPlatform: InAppWebViewOptions(
              verticalScrollBarEnabled: false,
              horizontalScrollBarEnabled: false,
              preferredContentMode: UserPreferredContentMode.RECOMMENDED,
              supportZoom: true,
              transparentBackground: true,
              minimumFontSize: 15),
        ),
        onWebViewCreated: (webController) async {
          _inAppWebViewController = webController;
        },
        onLoadStart: (controller, url) {},
        onLoadStop: (controller, url) {
          setState(() {
            _webViewOpacity = 1;

            ///执行JS
            debugPrint("loadECharts($_currentOption)");
            _inAppWebViewController?.evaluateJavascript(source: "loadECharts($_currentOption)");
          });
        },
        onLoadError: (controller, url, code, message) {
          debugPrint("loadECharts failed with error: $code $message");
        },
        onProgressChanged: (controller, progress) {},
        onUpdateVisitedHistory: (controller, url, androidIsReload) {},
        onConsoleMessage: (controller, consoleMessage) {
          debugPrint('$consoleMessage');
        },
        androidOnPermissionRequest: (controller, origin, resources) async {
          return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          var uri = navigationAction.request.url!;

          if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
            return NavigationActionPolicy.CANCEL;
          }

          return NavigationActionPolicy.ALLOW;
        },
      ),
    );
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      _inAppWebViewController?.clearCache();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant KSEChartsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _update(oldWidget.option);
  }

  _update(String preOption) async {
    _currentOption = widget.option;
    if (_currentOption != preOption) {
      await _inAppWebViewController?.evaluateJavascript(source: "loadECharts(${widget.option})");
    }
  }
}
