import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KSCustomPopupWidgetController {
  final KSCustomPopupWidgetConfig config;
  KSCustomPopupWidgetController({required this.config});

  late AnimationController _popupanimationController;
  late AnimationController _opacityanimationController;

  Future dismissAnimation() {
    _opacityanimationController.reverse();
    return _popupanimationController.reverse().then((value) {
      if (config.onClose != null) {
        config.onClose!();
      }
    });
  }
}

class KSCustomPopupRoute extends PageRouteBuilder {
  final Widget contentWidget;
  final KSCustomPopupWidgetController customPopupWidgetController;

  KSCustomPopupRoute({required this.contentWidget, required this.customPopupWidgetController})
      : super(
            pageBuilder: (context, _, __) => KSCustomPopupWidget(
                  key: UniqueKey(),
                  contentWidget: contentWidget,
                  customPopupWidgetController: customPopupWidgetController,
                ),
            opaque: false);
}

class KSCustomPopupWidget extends StatefulWidget {
  final Widget contentWidget;
  final KSCustomPopupWidgetController customPopupWidgetController;

  const KSCustomPopupWidget({Key? key, required this.contentWidget, required this.customPopupWidgetController}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return KSCustomPopupWidgetState(contentWidget: contentWidget, customPopupWidgetController: customPopupWidgetController);
  }
}

class KSCustomPopupWidgetState extends State<KSCustomPopupWidget> with TickerProviderStateMixin {
  final Widget contentWidget;
  final KSCustomPopupWidgetController customPopupWidgetController;

  KSCustomPopupWidgetState({required this.contentWidget, required this.customPopupWidgetController});

  late Animation<double> _popupanimation;

  late Animation<double> _opacityanimation;

  @override
  void initState() {
    super.initState();

    customPopupWidgetController._popupanimationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _popupanimation =
        Tween<double>(begin: customPopupWidgetController.config.targetPositionStart, end: customPopupWidgetController.config.targetPositionEnd)
            .animate(customPopupWidgetController._popupanimationController)
          ..addListener(() {
            setState(() {});
          });
    customPopupWidgetController._popupanimationController.forward();

    customPopupWidgetController._opacityanimationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _opacityanimation = Tween<double>(begin: 0, end: 1).animate(customPopupWidgetController._opacityanimationController)
      ..addListener(() {
        setState(() {});
      });
    customPopupWidgetController._opacityanimationController.forward();
  }

  void closePopup() {
    customPopupWidgetController._opacityanimationController.reverse();
    customPopupWidgetController._popupanimationController.reverse().then((value) {
      Navigator.pop(context);
      if (customPopupWidgetController.config.onClose != null) {
        customPopupWidgetController.config.onClose!();
      }
    });
  }

  @override
  void dispose() {
    customPopupWidgetController._popupanimationController.dispose();
    customPopupWidgetController._opacityanimationController.dispose();
    super.dispose();
  }

  late double screenWidth;
  late double screenHeight;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    final double topViewWidth = (customPopupWidgetController.config.direction == KSCustomPopupWidgetConfig.direction_top2bottom ||
            customPopupWidgetController.config.direction == KSCustomPopupWidgetConfig.direction_bottom2top)
        ? screenWidth
        : (customPopupWidgetController.config.targetPositionEnd + customPopupWidgetController.config.popupWidth);
    final double topViewHeight = (customPopupWidgetController.config.direction == KSCustomPopupWidgetConfig.direction_top2bottom ||
            customPopupWidgetController.config.direction == KSCustomPopupWidgetConfig.direction_bottom2top)
        ? (customPopupWidgetController.config.targetPositionEnd + customPopupWidgetController.config.popupHeight)
        : screenHeight;
    final bottomViewWidth = (customPopupWidgetController.config.direction == KSCustomPopupWidgetConfig.direction_top2bottom ||
            customPopupWidgetController.config.direction == KSCustomPopupWidgetConfig.direction_bottom2top)
        ? screenWidth
        : (screenWidth - customPopupWidgetController.config.popupWidth - customPopupWidgetController.config.targetPositionEnd);
    final bottomViewHeight = (customPopupWidgetController.config.direction == KSCustomPopupWidgetConfig.direction_top2bottom ||
            customPopupWidgetController.config.direction == KSCustomPopupWidgetConfig.direction_bottom2top)
        ? (screenHeight - customPopupWidgetController.config.popupHeight - customPopupWidgetController.config.targetPositionEnd)
        : screenHeight;
    return WillPopScope(
        onWillPop: () async => false,
        child: Opacity(
            opacity: _opacityanimation.value,
            child: Scaffold(
              resizeToAvoidBottomInset: customPopupWidgetController.config.resizeToAvoidBottomInset ?? true,
              backgroundColor: Colors.transparent,
              body: Container(
                alignment: Alignment.topCenter,
                width: screenWidth,
                height: screenHeight,
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Positioned(
                        top: (customPopupWidgetController.config.direction == KSCustomPopupWidgetConfig.direction_top2bottom ||
                                customPopupWidgetController.config.direction == KSCustomPopupWidgetConfig.direction_bottom2top)
                            ? 0
                            : null,
                        left: (customPopupWidgetController.config.direction == KSCustomPopupWidgetConfig.direction_top2bottom ||
                                customPopupWidgetController.config.direction == KSCustomPopupWidgetConfig.direction_bottom2top)
                            ? null
                            : 0,
                        child: Offstage(
                          offstage: topViewWidth <= 0 || topViewHeight <= 0,
                          child: GestureDetector(
                            onTap: () {
                              if (customPopupWidgetController.config.canTopClick == true) {
                                closePopup();
                              }
                            },
                            child: Container(
                              width: topViewWidth > 0 ? topViewWidth : 1,
                              height: topViewHeight > 0 ? topViewHeight : 1,
                              color: customPopupWidgetController.config.topBackgroundColor,
                            ),
                          ),
                        )),
                    Positioned(
                        bottom: (customPopupWidgetController.config.direction == KSCustomPopupWidgetConfig.direction_top2bottom ||
                                customPopupWidgetController.config.direction == KSCustomPopupWidgetConfig.direction_bottom2top)
                            ? 0
                            : null,
                        right: (customPopupWidgetController.config.direction == KSCustomPopupWidgetConfig.direction_top2bottom ||
                                customPopupWidgetController.config.direction == KSCustomPopupWidgetConfig.direction_bottom2top)
                            ? null
                            : 0,
                        child: Offstage(
                          offstage: bottomViewWidth <= 0 || bottomViewHeight <= 0,
                          child: GestureDetector(
                            onTap: () {
                              if (customPopupWidgetController.config.canBottomClick == true) {
                                closePopup();
                              }
                            },
                            child: Container(
                              width: bottomViewWidth > 0 ? bottomViewWidth : 1,
                              height: bottomViewHeight > 0 ? bottomViewHeight : 1,
                              color: customPopupWidgetController.config.bottomBackgroundColor,
                            ),
                          ),
                        )),
                    (customPopupWidgetController.config.direction == KSCustomPopupWidgetConfig.direction_top2bottom ||
                            customPopupWidgetController.config.direction == KSCustomPopupWidgetConfig.direction_bottom2top)
                        ? (customPopupWidgetController.config.direction == KSCustomPopupWidgetConfig.direction_top2bottom
                            ? Positioned(top: _popupanimation.value, child: _contentWidget())
                            : Positioned(
                                bottom: screenHeight - customPopupWidgetController.config.popupHeight - _popupanimation.value,
                                child: _contentWidget()))
                        : (customPopupWidgetController.config.direction == KSCustomPopupWidgetConfig.direction_left2right
                            ? Positioned(left: _popupanimation.value, child: _contentWidget())
                            : Positioned(
                                right: screenHeight - customPopupWidgetController.config.popupHeight - _popupanimation.value,
                                child: _contentWidget())),
                  ],
                ),
              ),
            )));
  }

  Widget _contentWidget() {
    double leftOffSet = customPopupWidgetController.config.leftOffset == null
        ? ((customPopupWidgetController.config.direction == KSCustomPopupWidgetConfig.direction_top2bottom ||
                customPopupWidgetController.config.direction == KSCustomPopupWidgetConfig.direction_bottom2top)
            ? (screenWidth - customPopupWidgetController.config.popupWidth) / 2
            : 0)
        : customPopupWidgetController.config.leftOffset!;
    return Padding(
      padding: EdgeInsets.only(left: leftOffSet),
      child: Container(
        width: customPopupWidgetController.config.popupWidth,
        height: customPopupWidgetController.config.popupHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: customPopupWidgetController.config.contentColor ?? Colors.transparent,
            borderRadius: customPopupWidgetController.config.borderRadius == null
                ? null
                : BorderRadius.circular(customPopupWidgetController.config.borderRadius!)),
        child: Stack(
          children: [
            contentWidget,
            Positioned(
                top: 0,
                right: 0,
                child: Offstage(
                  offstage: customPopupWidgetController.config.showCloseButton != true,
                  child: SizedBox(
                    width: 50.w,
                    height: 50.w,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        closePopup();
                      },
                      icon: Icon(
                        Icons.close_rounded,
                        color: const Color(0xFFCCCCCC),
                        size: 30.w,
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class KSCustomPopupWidgetConfig {
  static const int direction_top2bottom = 1;
  static const int direction_bottom2top = 2;
  static const int direction_left2right = 3;
  static const int direction_right2left = 4;

  double targetPositionStart = 0;
  double targetPositionEnd = 0;
  int direction = direction_top2bottom;
  bool? canTopClick;
  bool? canBottomClick;
  bool? showCloseButton;

  late double popupWidth;
  late double popupHeight;
  double? borderRadius;
  Color? contentColor;
  late Color topBackgroundColor;
  late Color bottomBackgroundColor;
  bool? resizeToAvoidBottomInset;
  Function? onClose;

  ///距离左边间距，没有的话默认横向居中
  double? leftOffset;

  KSCustomPopupWidgetConfig(
      {required this.direction,
      required this.targetPositionStart,
      required this.targetPositionEnd,
      required this.popupWidth,
      required this.popupHeight,
      this.borderRadius,
      this.canTopClick,
      this.canBottomClick,
      this.showCloseButton,
      this.contentColor,
      this.leftOffset,
      Color? topBackgroundColor,
      Color? bottomBackgroundColor,
      this.resizeToAvoidBottomInset,
      this.onClose}) {
    this.topBackgroundColor = topBackgroundColor ?? Colors.black.withOpacity(0.3);
    this.bottomBackgroundColor = bottomBackgroundColor ?? Colors.black.withOpacity(0.3);
  }
}
